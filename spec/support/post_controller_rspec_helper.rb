module PostControllerRspecHelper
  
  def mock_post(lat, lng, water_height, member)

    post = Post.create(:location=> [lat, lng],
                        :image => "",
                        :message => "msg",
                        :place => "place",
                        :water_height => water_height,
                        :member_id => member.id
                        )

    return post

  end
  
end