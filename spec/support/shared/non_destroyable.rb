shared_examples_for 'non-destroyable' do
  it 'not deletes the object' do
    expect { request }.to_not change(model, :count)
  end

  it 'renders forbidden' do
    request
    expect(response.status).to eq 403
  end
end
