require 'reform/form/dry'

module User::Contract
  class EditTable < Reform::Form
    feature Reform::Form::Dry

    property :edit_table, virtual: true # used as index
    property :user_id, virtual: true # used as index
    property :title, virtual: true
    property :params_list, virtual: true
    property :unm_list, virtual: true

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def same_size?
          form.params_list.split(',').size == form.unm_list.split(',').size
        end

        def acceptable_params?
          user = User.find(form.id)
          params_list = user.content['report_settings']['params_list']
          ergo_params_list = user.content['report_settings']['ergo_params_list']

          form.params_list.split(',').each do |param|
            return false if params_list.exclude?(param) && ergo_params_list.exclude?(param)
            true
          end
        end
      end

      required(:params_list).filled(:same_size?, :acceptable_params?)
      required(:unm_list).filled(:same_size?)
    end
  end
end
