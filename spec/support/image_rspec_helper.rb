module ImageRspecHelper
  
  
  
  def mock_temp_image
    
    @image_unique_id ||= 0
    @image_unique_id += 1
    
    path = "/uploads/temp/taylor_swift_2__#{@image_unique_id}.jpg"
    
    FileUtils.copy(File.expand_path("../../assets/taylor_swift_2.jpg",__FILE__), 
                    File.join(Rails.root, "public", path))
                    
    return path
    
  end
  
  
  def mock_image
    
    @image_unique_id ||= 0
    @image_unique_id += 1
    
    path = "/uploads/temp/taylor_swift__#{@image_unique_id}.jpg"
    
    FileUtils.copy(File.expand_path("../../assets/taylor_swift.jpg",__FILE__), 
                  File.join(Rails.root, "public", path))

    return path
    
  end
  
  
  def verify_image(class_entity, path, exist)
    
    File.exists?(File.join(Rails.root, "public", path)).should == exist
    
    class_entity.thumbnail_sizes.each { |wh|
      thumb_path = class_entity.get_thumbnail_image_path(File.join(Rails.root, "public", path), wh[:w], wh[:h])
      File.exists?(thumb_path).should == exist
    }
    
  end
  
end