require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }

  describe 'DELETE #destroy' do
    context 'question' do
      before do
        add_file_to(question)
      end

      it 'author can delete question attachment' do
        login(author)
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
        end.to change(question.files, :count).by(-1)
        expect(response).to_not redirect_to question_path(question)
      end

      it "user can't delete question attachment" do
        login(user)
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
        end.to_not change(question.files, :count)
        expect(response).to redirect_to question_path(question)
      end

      it "guest can't delete question attachment" do
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
        end.to_not change(question.files, :count)
        expect(response).to have_http_status(401)
      end
    end

    context 'answer' do
      before do
        add_file_to(answer)
      end

      it 'author can delete answer attachment' do
        login(author)
        expect do
          delete :destroy, params: { id: answer.files.first }, format: :js
        end.to change(answer.files, :count).by(-1)
        expect(response).to_not redirect_to answer_path(answer.question)
      end

      it "userr can't delete answer attachment" do
        login(user)
        expect do
          delete :destroy, params: { id: answer.files.first }, format: :js
        end.to_not change(answer.files, :count)
        expect(response).to redirect_to answer_path(answer)
      end

      it "quest can't delete answer attachment" do
        login(author)
        expect do
          delete :destroy, params: { id: answer.files.first }, format: :js
        end.to_not change(answer.files, :count)
        expect(response).to have_http_status(401)
      end
    end
  end
end
