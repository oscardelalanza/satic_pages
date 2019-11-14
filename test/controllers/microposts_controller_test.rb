require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
  end
  
  test "should redirect create when not logged id" do
    assert_no_difference 'Micropost.count' do
      post micropost_path, params: {
        micropost: {
          content: "Lorem ipsum",
        }
      }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference  'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
end
