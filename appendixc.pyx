# Import native Python modules

import comparison, os, shutil, sys, time

# Import our custom made Pyrex and Python extensions

import fpBnW01, fpWalk01

import ImageAnalyzer

# Add the path where the fingerprints are stored

imageDirectory = 'C:\\Python25\\Lib\\site­packages\\Pyrex\\Distutils\\2002 fvc 110 by
8\\Processed\\'

textFileDirectory = 'C:\\Python25\\Lib\\site­packages\\Pyrex\\Distutils\\2002 fvc 110 by
8\\textFiles\\'

os.sys.path.append(imageDirectory)

os.sys.path.append(textFileDirectory)




# Take care of some pre­loop needs

startTime = time.time()

iterations = 500000

startingScale = 0

endingScale = 30

increment = 0.5



# A text file will be created for each of the 880 outlined images

for iLoop in range(6,7):

   for iLoop2 in range(5,6):
   
      sName = str(iLoop) + '_' + str(iLoop2) + '.bmp'
      
      image = ImageAnalyzer.ImageAnalyzer(imageDirectory, sName)
      
      results = image.monochromeWalk(iterations, startingScale, endingScale, increment)
      
      if (type(results) == type(1)):
      
         print '\nprint was skipped\n'
         
      else:
      
         p1TextFile = open(textFileDirectory + str(iLoop) + '_' + str(iLoop2)      +'.txt','w')
         
         p1TextFile.write(str(iLoop) + '_' + str(iLoop2) + 'b.txt' + '\n')
         
         p1TextFile.write('Created on ' + str(time.asctime()) + '\n')
         
         p1TextFile.write('File created by Joseph M. Stoffa\n\n')
         
         p1TextFile.write(' D(mm)\t Pbb\t Pww\t Pwb\n­­­­­­\t­­­­­­\t­­­­­­\t­­­­­­\n')
         
         for iLoop3 in range(0, int(float(endingScale)/float(increment)) + 1):
         
            scale = str('%.4f'%(results[iLoop3][0] * 0.08467))
            
            p1TextFile.write(scale + '\t' + str(results[iLoop3][1]) + '\t')
            
            p1TextFile.write(str(results[iLoop3][2]) + '\t' + str(results[iLoop3][3]) + '\n')
            
         p1TextFile.close()
         
         print 'Text file for ', sName, ' has been created'
         
totalTime = time.time()-startTime

print 'The total time taken was ', totalTime

print 'FIN'
