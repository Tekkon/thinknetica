require 'rails_helper'

RSpec.describe Attachment, type: :model do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachmentable: question, file: Rails.root.join("spec/spec_helper.rb").open)}

  it { should belong_to :attachmentable }

  it "#filename" do
    expect(attachment.filename).to eq 'spec_helper.rb'
  end
end
