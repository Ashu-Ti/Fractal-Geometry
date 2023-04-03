# Import the C functions we will need during our random walk

cdef extern from "math.h":

 double cos(double theta)
 double sin(double theta)
 double acos(double negOneToOne)
 double sqrt(double number)
 double pow(double base, double exp)
 float floor(float decimal)
 
# Import C functions necessary for creating and destroying large arrays

cdef extern from "stdlib.h":

 void *malloc(int size)
 void free(void *ptr)
 
 
def gridWalk(path, name, variableList):


 # Import the necessary python extensions
 
 import random
 
 # Define the necessary C variables
 
 cdef short int iHeight
 cdef short int iWdth
 cdef float fScale
 cdef short int iEdgeLength
 cdef int iIterations
 cdef int iRow
 cdef int iColumn
 cdef int iNetRow
 cdef int iNetColumn
 cdef short int iIsGreen
 cdef short int iIsOB
 cdef int iCounter
 cdef int iCounter2
 cdef float fHyp
 cdef float fX
 cdef float fY
 cdef float fXStar
 cdef float fYStar
 cdef int iXOffset
 cdef int iYOffset
 cdef float fThetaRandom
 cdef float fThetaRaw
 cdef float fThetaAdjusted
 cdef short in iIndex
 cdef short int iPow
 cdef short int iX
 cdef short int iY
 cdef char *image
 cdef unsigned char *net
 
 
 # Use malloc to dynamically create two potentially large c arrays
 # The first array represents the image file
 # The second array represents the walk data at a given scale
 
 image = malloc(2 * iHeight * iWidth)
 net = malloc(2 * iEdgeLength * iEdgeLength)
 
 if(image == NULL):
 
    # Malloc was unsuccessful, we can not continue
    
    print ("There was not enough memory to create the image array")
    
    return -­101
    
 if(net == NULL):
 
    # Malloc was unsuccessful, we can not continue
    
    print "There was not enough memory to create the net array"
    
    return ­-101
    
 if(iIterations % 8 != 0):
 
    # We can not properly compress data unless iIterations % 8 is 0
    
    print ("The number of iterations must be exactly divisible by 8")
    
    return -­102
    
 # Open a text file to store the results of the walk
 
 fout = open("C:\\netWalkScale22.txt","w")
 
 
 # Determine and store information related to the image
 
 self.im = Image.open(path + name)
 
 iWidth = self.im.size[0]

 iHeight = self.im.size[1]

 # The following code places the images BnW values into a C array
 
 orig_pixels = self.im.getdata()
 
 
 pixelList = []
 
 for i in range(0,len(orig_pixels)):
 
    pixelList.append(orig_pixels[i])
    
 imageTuple = tuple(pixelList)
 

 # We now transfer the Python list representation of the image into

 # a C array of characters where:

 # A value of 0 represents black

 # A value of 1 represents white

 # A value of ­1 represents the green mask

 for iRow from 0 <= iRow < iHeight:

    for iColumn from 0 <= iColumn < iWidth:
    
       # Check to see if we are outside of the green mask
       
       if((imageTuple[iRow * iWidth + iColumn][0] + imageTuple[iRow * iWidth + iColumn][1])
!= 255):

          # We are outside of the green mask, transfer the value into a C array
          
          if(imageTuple[iRow * iWidth + iColumn][0] == 0):
          
             image[iRow * iWidth + iColumn] = 0
             
          else:
          
             image[iRow * iWidth + iColumn] = 1
             
       else:
       
          # The pixel is green
          
          image[iRow * iWidth + iColumn] =-1
          
 # Store the python random walk variables as C variables
 
 fScale = variableList[0]
 iEdgeLength = variableList[1]
 iIterations = variableList[2]
 
 # Seed the random number generator with the system time
 
 random.seed()
 
 
 # Initialize our net array
 
 for iCounter2 from 0 <= iCounter2 < pow(iEdgeLength, 2):
 
    net[iCounter2] = 0
    
    
 # Loop where iterations are performed
 
 for iCounter from 1 <= iCounter <= iIterations:
 
    # Initialize our variables that ensure valid point selection
    
    iIsGreen = 0
    
    iIsOB = 0
    
    
    # Enter a loop where we pick points until we get valid ones
    
    while(iIsGreen == 0 or iIsOB == 0):
    
       # Assume all points in our net are valid ­­- until we find otherwise
       
       iIsGreen = 1
       
       iIsOB = 1
       
       # Choose the center and angle of our net
       
       fX = iWidth * random.random()
       
       fY = iHeight * random.random()
       
       fThetaRandom = 2 * 3.14159 * random.random()
       
       # Enter a loop check all n x n grid points for validity
       
       for iNetRow from 0 <= iNetRow < iEdgeLength:
       
          for iNetColumn from 0 <= iNetColumn < iEdgeLength:
          
             iXOffset = (iNetColumn­-floor(iEdgeLength/2))
             
             iYOffset = (iNetRow-floor(iEdgeLength/2))
             
             fHyp = sqrt(iXOffset * iXOffset + iYOffset * iYOffset)
             
             if(fHyp != 0):
             
                # Determine which of the four quadrants we are in
                
                if(iYOffset >= 0):
                
                   # We are in quandrant I or quadrant II
                   
                   fThetaRaw = acos(iXOffset/fHyp)
                   
                else:
                
                   # We are in quadrant III or quadrant IV
                   
                   fThetaRaw = 2 * 3.14159265-acos(iXOffset/fHyp)
                   
             # Adjust our random angle with our net point angle
             
             fThetaAdjusted = fThetaRandom + fThetaRaw
             
             # Calculate real hypotenuse
             
             fHyp = fHyp * fScale / 2
             
             fHyp = fHyp / sqrt(2 * floor(iEdgeLength/2) * floor(iEdgeLength/2))
             
             fXStar = fX + fHyp * cos(fThetaAdjusted)
             
             fYStar = fY + fHyp * sin(fThetaAdjusted)
             
             # Now we have the x and y coordinates of a particular net point
             
             # Now we can check to see if these points are in bounds
             
             iX = fXStar
             
             iY = fYStar
             
             if(iX < 0 or iX >= iWidth of iY < 0 or iY >= iHeight):
             
                iIsOB = 0
                
                break
                
             # If the point was not OB, it may be green
             
             if(image[iY * iWidth + iX] ==­-1):
             
                iIsGreen = 0
                
                break
                
          # End of iNetColumn for loop
             
          # Check to see if we are OB or the point is green
          
          if(iIsOB == 0 or iIsGreen == 0):
          
             break
             
       # End of iNetRow for loop
       
    # End iIsOB or iIsGreen while loop
    
    
    # If we've made it this far we have a valid net of points
    
    for iNetRow from 0 <= iNetRow < iEdgeLength:
    
       for iNetColumn from 0 <= iNetColumn < iEdgeLength:
       
          iXOffset = (iNetColumn-floor(iEdgeLength/2))
          
          iYOffset = (iNetRow-floor(iEdgeLength/2))
          
          fHyp = sqrt(iXOffset * iXOffset + iYOffset * iYOffset)
          
          if(fHyp != 0):
          
             # Determine which of the four quadrants we are in
             
             if(iYOffset >= 0):
             
                # We are in quandrant I or quadrant II
                
                fThetaRaw = acos(iXOffset/fHyp)
                
             else:
             
                # We are in quadrant III or quadrant IV
                
                fThetaRaw = 2 * 3.14159265-acos(iXOffset/fHyp)
                
          # Adjust our random angle with our net point angle
          
          fThetaAdjusted = fThetaRandom + fThetaRaw
          
          # Calculate real hypotenuse
          
          fHyp = fHyp * fScale / 2
          
          fHyp = fHyp / sqrt(2 * floor(iEdgeLength/2) * floor(iEdgeLength/2))
          
          fXStar = fX + fHyp * cos(fThetaAdjusted)
          
          fYStar = fY + fHyp * sin(fThetaAdjusted)
          
          # Now we have the x and y coordinates of a particular net point
          
          # Now we can check to see if these points are in bounds
          
          iX = fXStar
          
          iY = fYStar
          
          # Test the color of one particular net pixel
          
          iIndex = iNetRow * iEdgeLength + iNetColumn
          
          iPow = iCounter % 8
          
          if(image[iY * iWidth + iX] == 0):
          
             # Our pixel is black
             
             # We always add zero if the pixel is black, so we take no action
             
          elif(image[iY * iWidth + iX] == 1):
          
             # Our pixel is white
             
             net[iIndex] = net[iIndex] + pow(2, iPow)
             
          else:
          
             # We should never see this!
             
             print "We have an error in the code that compresses the eight net values"
             
          # See if we have 8 values in our array, if so compress them into a single line in
           a .txt file
           
          if(iIterations % 8 == 0):
          
             # Compress the values into a single line of a .txt file
             
             for iCounter2 from 0 <= iCounter2 < pow(iEdgeLength, 2):
             
                # If we need any leading zeros, add them here
                
                if(net[iCounter2] > 99):
                
                   str = str + net[index]
                   
                elif(net[iCounter2] > 9 and net[index] < 100):
                
                   str = str + '0' + net[index]
                   
                elif(net[iCounter2] >= 0 and net[index] < 10):
                
                   str = str + '00' + net[index]
                   
                else:
                
                   print ("We have an error in the code section that adds leading zeros")
                   
                # Add a space after the value
                
                str = str + ' '
                
                # Write the string to the file
                
                fout.write(str) 
                
                # initialize our array for the next round
                
                net[iCounter2] = 0
                
             # End of iCounter2 for loop
             
          # End of .txt line write
          
       # End of iNetColumn for loop
       
    # End of iNetRow for loop
    
 # End of iIterations for loop


 
 # Free the memory associated with the malloc call
 
 free(image)
 
 free(net)
 
 
 # Close the text file we've created
 
 fout.close()
 
 
 
 # Successfully return
 
 return 0
