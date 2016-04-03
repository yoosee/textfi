class ArticlesControllerTest < ActionController::TestCase

  test "should create article" do
    assert_difference 'Article.count' do
      post :create, article: { title: 'test title' }
    end
    assert_redirected_to article_path(assigns :article)
  end

  test "get index" do
    get :index
    assert_response :success
    assert_not_nil assigns :articles
  end
  
  test "get individual by alt_url" do
    assert_response :success
    assert_not_nil assigns :article
  end


end
