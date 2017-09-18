shared_examples_for 'destroyable' do
  it 'deletes the object' do
    expect { request }.to change(model, :count).by(-1)
  end

  it 'renders destroy template' do
    request
    expect(response).to render_template :destroy
  end
end
