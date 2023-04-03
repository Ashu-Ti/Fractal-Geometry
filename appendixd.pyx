# Import the necessary Python libraries

import random



def comparison(printOne, printTwo, metric, quantity, startingScale = 0, endingScale = 9999):



   # This is where the module documentation is stored

   """

   The comparison module compares two fingerprints

   The listData input is a python list containing data on two fingerprints


      printOne[0][0...n] is the scale data for fingerprint one
   
      printOne[1][0...n] is the alpha1 data for fingerprint one
   
      printOne[2][0...n] is the alpha2 data for fingerprint one
   
      printOne[3][0...n] is the beta data for fingerprint one
   
      printTwo[0][0...n] is the scale data for fingerprint two
   
      printTwo[1][0...n] is the alpha1 data for fingerprint two
   
      printTwo[2][0...n] is the alpha2 data for fingerprint two
   
      printTwo[3][0...n] is the beta data for fingerprint two
      
   The "metric" variable refers to the method of comparison
   
   The following text arguments are valid for the metric variable
   
      linear--Computes the linear distance between two spectra
      
      square--Computes the square of the linear distance between two spectra
      
      FFT--computes the linear difference between the Fourier transform of two spectra
      
   The "quantity" variable determines what the "metric" compares
   
   The following text arguments are valid for the quantity variable
   
      alphaOne--­­The quantity measured by the metric will be the probability of white­white
      
      alphaTwo--­­Quantity compared will be probability of black­black
      
      beta--Quantity compared will be probability of black­white + white­black
      
      determinan--­­Quantity compared will be the determinant of the 2x2 matrix
      
      eigenValues--Quantity compared will be the Eigenvalues of the 2x2 matrix
      
      trace--Quantity compared will be the trace of the 2x2 matrix
      
   The startingScale and endingScale determine which section of spectra undergoes comparison
   
   If these areguments are omitted, all scales will be compared
   
   The startingScale and endingScale are inclusive, these scales will be compared
   
   Any two numerical arguments for the startingScale and endingScale are valid given that
   
      The startingScale is less than the endingScale
      
   """
   
   # Check to see if arguments are valid
   
   # Check if listData is a variable of type list
   
   if(type(printOne) != type([]) or type(printTwo) != type([])):
   
      # Our input is not a list, we need to return an error value
      
      return ­-230
      
   # Check if data representing alphas and beta is in integer form
   
   for iLoop in range(1,4):
   
      if(type(printOne[iLoop][0]) != type(1) or type(printTwo[iLoop][0]) != type(1)):
      
         return -­231
         
   # Check that the user has selected an acceptable metric
   
   if(metric != 'linear' and metric != 'percentage' and metric != 'square'):
   
      return -­232
         
   # Check that the user has selected a valid quantity to comapre
   
   if(quantity != 'alphaOne' and quantity != 'alphaTwo' and quantity != 'beta'):
   
      if(quantity != 'determinant' and quantity != 'eigenValues' and quantity != 'trace'):
      
         if(quantity != 'ndeterminant' and quantity != 'random'):
         
            return -­233
            
   # Check to ensure the starting scale is smaller than the ending scale
   
   if(startingScale > endingScale):
   
      return ­-234
      
   # We need to determine the number of entries in printOne
   
   entries = len(printOne[0])
   
   # We need to determine the index of our startingScale
   
   startingIndex = 0
   
   while(startingScale > printOne[0][startingIndex]):
   
      startingIndex = startingIndex + 1
      
      if(startingIndex > entries):
      
         # Our startingScale is greater than the last scale in the data list
         
         return -­235
         
   # Determine the number of iterations that occur at each scale of fingerprint 1
   
   # This assumes the number of iterations that occured at the first scale occur at all scales
   
   # Also, fingerprint 1 and 2 must have the same number of iterations at each scale
   
   # Otherwise, the comparison result will be fingerprint order specific
   
   iterations = printOne[1][0] + printOne[2][0] + 2*printOne[3][0]
   
   alphaOneW0 = printOne[1][0]
   
   alphaOneB0 = printOne[2][0]
   
   alphaTwoW0 = printTwo[1][0]
   
   alphaTwoB0 = printTwo[2][0]
   
   # Initialize some variables before entering our loop
   
   differenceSum = 0
   
   iCounter = startingIndex
   
   iScalesCompared = 0
   
   # See if we reach the endingScale before we reach the last index in the print
   
   while(iCounter < entries and printOne[0][iCounter] <= endingScale):
   
      # Make certain our two scales are equal
      
      if(printOne[0][iCounter] != printTwo[0][iCounter]):
      
         return ­-236
         
      # Determine the difference based on our metric
      
      if(quantity == 'alphaOne'):
      
         # Calculate the difference between the alpha ones
         
         difference = abs(printOne[1][iCounter]-printTwo[1][iCounter])
         
      elif(quantity == 'alphaTwo'):
      
         # Calculate the difference between the alpha twos
         
         difference = abs(printOne[2][iCounter]-printTwo[2][iCounter])
         
      elif(quantity == 'beta'):
      
         # Calculate the difference between the betas
         
         difference = abs(printOne[3][iCounter]-printTwo[3][iCounter])
         
      elif(quantity == 'determinant'):
      
         # Calculate the difference between the two determinants
         
         difference = (printOne[1][iCounter]*printOne[2][iCounter]-­pow(printOne[3][iCounter],2))
         
         difference = abs(difference-(printTwo[1][iCounter]*printTwo[2][iCounter]-pow(printTwo[3][icounter],2)))
          ­
      elif(quantity == 'random'):
      
         # Calculate the difference between the two determinants
         
         difference = random.random()
         
      elif(quantity == 'ndeterminant'):
      
         # Calculate the difference between the two determinants
         
         difference = (printOne[1][iCounter]*printOne[2][iCounter]-pow(printOne[3][iCounter],2))/alphaOneW0/alphaOneB0
         
         difference = abs(difference-((printTwo[1][iCounter]*printTwo[2][iCounter]-pow(printTwo[3][iCounter], 2))/alphaTwoW0/alphaTwoB0))
         

         """
         
         elif(quantity == 'eigenvalues'):
         
         # Do something else
         
         return ­-237
         
         """
         
      elif(quantity == 'trace'):
      
         # Calculate the difference between the two traces
         
         difference = printOne[1][iCounter] + printOne[2][iCounter]
         
         difference = abs(difference-printTwo[1][iCounter]-printTwo[2][iCounter])
         
      else:
      
         # We should never see this line of code
         
         return ­-237
         

      error = (pow(printOne[1][iCounter], 0.5) + pow(printTwo[1][iCounter], 0.5))/2*2*.7
      
      if(quantity == 'determinant'):
      
         error = pow(error, 2)


         
      if(metric == 'square'):
      
         difference = pow(difference, 2)
         
         error = pow(error, 2)

         
      if(metric == 'percentage'):
      
         if(difference < error):
         
           difference = 0
           
        else:
        
           difference = 1

           
     # We've completed on difference calculation
     
     iCounter = iCounter + 1
     
     if(metric == 'linear' or metric == 'square'):
     
        differenceSum = differenceSum + float(difference)/float(error)
        
     if(metric == 'percentage'):
     
        differenceSum = differenceSum + difference
        
     iScalesCompared = iScalesCompared + 1

     
   # The main loop is over
   
   # We can now return the average difference between two scale spectra


   
   if(metric == 'linear' or metric == 'square'):
   
      return float(differenceSum/float(iScalesCompared))
      
   if(metric == 'percentage'):
   
      return float(1.0-float(differenceSum)/float(iScalesCompared))
      
