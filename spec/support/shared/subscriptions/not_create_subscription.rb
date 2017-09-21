shared_examples_for 'not create subscription' do
  it 'return status 422' do
    request
    expect(response.status).to eq 422
  end

  it 'does not create a subscription' do
    expect { request }.to_not change(Subscription, :count)
  end

  it 'renders error' do
    request
    expect(response.body).to have_json_path('error')
  end
end
