require 'rails_helper'

describe CreateTask do
  describe "#execute" do
    context "when params is invalid" do
      let(:invalid_task_params) {
        {
          descripion: nil
        }
      }

      let(:uc) { described_class }

      it 'raise error TaskException' do
        expect{ uc.new(task_params: invalid_task_params) }.to raise_error(TaskException)
      end
    end

    context "when params is valid" do
      let(:valid_task_params) {
        {
          description: "New Task",
          date: Time.zone.now
        }
      }

      let(:uc) { described_class }

      it 'build class successfully' do
        expect(uc.new(task_params: valid_task_params)).to be_instance_of(CreateTask)
      end

      context "and it is a parent task" do
        it 'create the task successfully' do
          task = uc.new(task_params: valid_task_params).execute

          expect(task.description).to eq(valid_task_params[:description])
          expect(Task.count).to eq(1)
        end
      end

      context 'and it is a subtask' do
        let(:parent_task) { create(:task) }

        let(:params) {
          {
            description: "New subtask",
            parent_id: parent_task.id,
          }
        }

        it 'create subtask successfully' do
          task = uc.new(task_params: params).execute

          expect(task.description).to eq(params[:description])
          expect(task.parent_id).to eq(parent_task.id)
          expect(task.date.to_date).to eq(parent_task.date.to_date)
          expect(Task.count).to eq(2)
        end

        context 'the date is different from the original task' do
          let(:parent_task) { create(:task) }
          let(:params) {
            {
              descripion: "My Description",
              parent_id: parent_task.id,
              date: parent_task.date + 1.day
            }
          }

          it 'raise error TaskException' do
            expect{ uc.new(task_params: params) }.to raise_error(TaskException)
          end
        end
      end
    end
  end
end