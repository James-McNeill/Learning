# Method to search for faces within an image
import matplotlib.pyplot as plt

def show_detected_face(result, detected, title="Face image"):
  plt.imshow(result)    
  img_desc = plt.gca()    
  plt.set_cmap('gray')    
  plt.title(title)    
  plt.axis('off')
  
  for patch in detected:        
    img_desc.add_patch(            
      patches.Rectangle(                
        (patch['c'], patch['r']),                
        patch['width'],                
        patch['height'],                
        fill=False,color='r',linewidth=2)        
    )    
    plt.show()
