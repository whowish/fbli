class ResizeJob
  extend ThumbnailismHelper
  extend TemporaryFileHelper
  
  @queue = :normal
  
  def self.perform(image_path, new_image_path, width, height)
    
    image_resize(image_path, 
                  width, 
                  height, 
                  new_image_path,
                  true)
    
  end
  
end