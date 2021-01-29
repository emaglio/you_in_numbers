module User::Cell
  class Index < Trailblazer::Cell
    def total
      model.size - 1
    end

    def user_array
      array = ''

      model.each_with_index do |user, index|
        next if user.email == 'admin@email.com'

        temp = []
        temp << user.id.to_s
        temp << user.email
        temp << user.firstname
        temp << user.lastname
        temp << user.gender
        temp << user.created_at.strftime('%d %B %Y at %m:%H %P')
        temp << ::Report.where(user_id: user.id).size
        temp << (button_to('Open', user_path(user), class: 'btn btn-outline btn-success', :method => :get))
        user.block ? label = 'Un-Block' : label = 'Block'
        temp << (button_to(label, block_users_path(id: user.id, block: !user.block),
                           method: :post, data: { confirm: 'Are you sure?' }, class: 'btn btn-outline btn-danger'))
        (index > 1) ? array += ',' : array
        array += temp.to_json
      end

      return array
    end
  end
end
