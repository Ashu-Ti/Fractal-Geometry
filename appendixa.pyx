import struct
import cStringIO
import Image

# Import C functions necessary for creating and destroying large arrays
cdef extern from "stdlib.h":
    void *malloc(int size)
    void free(void *ptr)

def transformOutline(imageTuple, variableList):
    # Define the necessary C variables
    cdef short int height
    cdef short int width
    cdef short int edgeLength
    cdef short int xLower
    cdef short int xUpper
    cdef short int yLower
    cdef short int yUpper
    cdef short int iLoop
    cdef short int iLoop2
    cdef short int iLoop3
    cdef short int iLoop4
    cdef int areaSum
    cdef int index
    cdef short int pixel
    cdef short int *image
    cdef short int *string
    cdef float averagePixel
    cdef float variance
    cdef float varianceLimit 
    cdef short int whiteLimit
    cdef short int blackLimit
    cdef int leftSum
    cdef int rightSum

    # Store the python outline variables as C variables
    width = variableList[0]
    height = variableList[1]
    edgeLength = variableList[2]
    varianceLimit = variableList[3]
    blackLimit = variableList[4]
    whiteLimit = variableList[5]

    # Use malloc to dynamically create potentially large c arrays
    image = <short*>malloc(2*height*width)
    string = <short*>malloc(2*height*width)

    if(image == NULL or string == NULL):
        # Malloc was unsuccessful, we can not continue
        return -101 

    yLower = edgeLength/2
    yUpper = height-yLower-1
    xLower = yLower
    xUpper = width-xLower-1

    # Transform python image tuple into a C array
    for iLoop from 0 <= iLoop < height:
        for iLoop2 from 0 <= iLoop2 < width:
            index = iLoop * width + iLoop2
            image[index] = imageTuple[index]

    # Perform the outlining transformation
    for iLoop from 0 <= iLoop < height:
        for iLoop2 from 0 <= iLoop2 < width:
            # Check to see if we are in bounds
            if(iLoop >= yLower and iLoop <= yUpper and iLoop2 >= xLower and iLoop2 <= xUpper):
                # We are in bounds, we can continue
                # Initialize the sum of our local area and the calculated variance
                areaSum = 0
                variance = 0
                for iLoop3 from 0 <= iLoop3 < edgeLength:
                    for iLoop4 from 0 <= iLoop4 < edgeLength:
                        # Calculate the index
                        index = (iLoop + iLoop3-edgeLength/2) * width
                        index = index + iLoop2 + iLoop4-edgeLength/2
                        areaSum = areaSum + image[index]
                # We have the sum over the area, no we can determine the average
                averagePixel = areaSum/(edgeLength * edgeLength)
                # Now that we have the average, we can caluclate the variance
                for iLoop3 from 0 <= iLoop3 < edgeLength:
                    for iLoop4 from 0 <= iLoop4 < edgeLength:
          
                       # Calculate the index
                      
                       index = (iLoop + iLoop3-edgeLength/2) * width
                
                       index = index + iLoop2 + iLoop4-edgeLength/2
                
                       variance = variance + (image[index]-averagePixel) * (image[index]-averagePixel)
                
                # Perform final variance calculation
          
                variance = variance / (edgeLength * edgeLength)
          
                # Determine if pixel should be masked or unmasked bade on variance
          
                index = iLoop * width + iLoop2
          
                if(variance < varianceLimit):
          
                   # There's not a lot of variance, we should mask this pixel
             
                   string[index] =-1
             
                else:
          
                   # There's variance here, probably not a smudge or open area
             
                   # Now we must determine if the pixel is white or black
             
                   if(averagePixel > whiteLimit):
             
                      # The pixel is easily classified as white
                
                      string[index] = 1
                
                   elif(averagePixel < blackLimit):
             
                      # The pixel is easily classified as black
                
                      string[index] = 0
                
                   else:
             
                      # We must do more work to determine if the pixel is black or white
                
                      if (image[index] > averagePixel):
                
                         # The pixel is lighter than it's sorroundings, call it white
                   
                         string[index] = 1
                    
                      else:
                
                         # The pixel must be black
                   
                         string[index] = 0
                   
            else:
       
               # We are not within the x and y boundaries, make the pixel green
          
               index = iLoop * width + iLoop2
          
               string[index] =-1 
          
    # Use a series of loops to transform the C string array into a python string
 
    out = cStringIO.StringIO()
 
    for iLoop from 0 <= iLoop < height:
 
       for iLoop2 from 0 <= iLoop2 < width:
    
          index = iLoop * width + iLoop2
       
          if(string[index] ==-1):
       
             # Our point should be masked, make it green
          
             bin_str = struct.pack("BBB", 0, 255, 0)
          
             out.write(bin_str)
          
          elif(string[index] == 0):
       
             # Our point is black
          
             bin_str = struct.pack("BBB", 0, 0, 0)
          
             out.write(bin_str)
          
          else:
       
             # Our point is white
          
             bin_str = struct.pack("BBB", 255, 255, 255)
          
             out.write(bin_str)
          
    # Don't forget to free the memory associated with the malloc'd arrays
 
   free(image)
 
   free(string)
 
   # Return an image variable
 
   tempTuple = (width, height)
 
   return Image.fromstring("RGB", tempTuple, out.getvalue())
