shared_examples_for 'non-savable' do
  it 'does not save the object' do
    expect { request }.to_not change(model, :count)
  end

  it 'renders template' do
    request
    expect(response).to render_template template
  end
end
