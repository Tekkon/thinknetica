shared_examples_for 'successable' do
  it 'returns status 200' do
    expect(response).to be_success
  end
end
