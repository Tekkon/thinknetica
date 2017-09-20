shared_examples_for 'after create' do
  it 'triggers create_subscription on create' do
    expect(object).to receive(method.to_sym)
    object.save
  end

  it 'does not trigger create_subscription on update' do
    object.save
    expect(object).to_not receive(method.to_sym)
    object.update(body: 'new')
  end
end
