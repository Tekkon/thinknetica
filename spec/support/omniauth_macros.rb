module OmniuathMacros
  def mock_twitter_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
        {
            provider: 'twitter',
            uid: '12345',
            info: {}
        })
  end

  def mock_facebook_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        {
            provider: 'facebook',
            uid: '12345',
            info: { email: 'test@email.com' }
        })
  end
end
