# frozen_string_literal: true

require 'test_helper.rb'

class SubjectOperationTest < MiniTest::Spec
  it 'create only if singed_in' do
    assert_raises ApplicationController::NotSignedIn do
      Subject::Create.(
        { user_id: 1,
          name: 'NewTitle' },
        'current_user' => nil
      )
    end
  end

  it 'wrong input' do
    user = User::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    user.success?.must_equal true

    result = Subject::Create.({}, 'current_user' => user)
    result.failure?.must_equal true
    result['result.contract.default'].errors.messages.inspect.must_equal '{:email=>["Wrong format"], '\
      ":user_id=>[\"Can't be blank\"], :firstname=>[\"Can't be blank\"], :lastname=>[\"Can't be blank\"],"\
      " :gender=>[\"Can't be blank\"], :dob=>[\"Can't be blank\"], :height=>[\"Can't be blank\", "\
      "\"This must be greater than zero\"], :weight=>[\"Can't be blank\", \"This must be greater than zero\"]}"
  end

  it 'create successfully' do
    user = User::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    user.success?.must_equal true

    result = Subject::Create.({
                                user_id: user['model'].id,
                                firstname: 'Ema',
                                lastname: 'Maglio',
                                gender: 'Male',
                                dob: '01/01/1980',
                                height: '180',
                                weight: '80',
                                phone: '912873',
                                email: 'ema@email.com'
                              }, 'current_user' => user)
    result.success?.must_equal true
    result['model'].firstname.must_equal 'Ema'
    result['model'].lastname.must_equal 'Maglio'
    result['model'].gender.must_equal 'Male'
    result['model'].dob.must_equal Time.parse('01/01/1980').to_date
    result['model'].height.must_equal 180
    result['model'].weight.must_equal 80
    result['model'].phone.must_equal '912873'
    result['model'].email.must_equal 'ema@email.com'
  end

  it 'unique subject and email' do
    user = User::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    user.success?.must_equal true

    subject = Subject::Create.({
                                 user_id: user['model'].id,
                                 firstname: 'Ema',
                                 lastname: 'Maglio',
                                 gender: 'Male',
                                 dob: '01/01/1980',
                                 height: '180',
                                 weight: '80',
                                 phone: '912873',
                                 email: 'ema@email.com'
                               }, 'current_user' => user)
    subject.success?.must_equal true

    result = Subject::Create.({
                                user_id: user['model'].id,
                                firstname: 'Ema',
                                lastname: 'Maglio',
                                gender: 'Male',
                                dob: '01/01/1980',
                                height: '180',
                                weight: '80',
                                phone: '912873',
                                email: 'ema@email.com'
                              }, 'current_user' => user)
    result.failure?.must_equal true
    result['result.contract.default'].errors.messages.inspect
      .must_equal '{:firstname=>["Subject already present in the database"]}'
  end

  it 'age between 5 and 120' do
    user = User::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    user.success?.must_equal true

    now = Time.now

    year_4_old = now - (365 * 4)
    year_121_old = now - (365 * 121)

    result = Subject::Create.({
                                user_id: user['model'].id,
                                firstname: 'Ema',
                                lastname: 'Maglio',
                                gender: 'Male',
                                dob: year_4_old.strftime('%d/%m/%Y'),
                                height: '180',
                                weight: '80',
                                phone: '912873',
                                email: 'ema@email.com'
                              }, 'current_user' => user)
    result.failure?.must_equal true
    result['result.contract.default'].errors.messages.inspect
      .must_equal '{:dob=>["Wrong age, Subject must be between 5 and 120 years old"]}'

    result = Subject::Create.({
                                user_id: user['model'].id,
                                firstname: 'Ema',
                                lastname: 'Maglio',
                                gender: 'Male',
                                dob: year_121_old.strftime('%d/%m/%Y'),
                                height: '180',
                                weight: '80',
                                phone: '912873',
                                email: 'ema@email.com'
                              }, 'current_user' => user)
    result.failure?.must_equal true
    result['result.contract.default'].errors.messages.inspect
      .must_equal '{:dob=>["Wrong age, Subject must be between 5 and 120 years old"]}'
  end

  it 'only owner can update subject' do
    user = User::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    user.success?.must_equal true
    user2 = User::Create.(email: 'tes2t@email.com', password: 'password', confirm_password: 'password')

    subject = Subject::Create.({
                                 user_id: user['model'].id,
                                 firstname: 'Ema',
                                 lastname: 'Maglio',
                                 gender: 'Male',
                                 dob: '01/01/1980',
                                 height: '180',
                                 weight: '80',
                                 phone: '912873',
                                 email: 'ema@email.com'
                               }, 'current_user' => user)
    subject.success?.must_equal true

    assert_raises ApplicationController::NotAuthorizedError do
      Subject::Update.(
        { id: subject['model'].id,
          firstname: 'NewName',
          dob: '01/01/1980' },
        'current_user' => user2['model']
      )
    end

    result = Subject::Update.(
      { id: subject['model'].id, firstname: 'NewEma', dob: '01/01/1980' },
      'current_user' => user['model']
    )
    result.success?.must_equal true
    result['model'].firstname.must_equal 'NewEma'
    result['model'].lastname.must_equal 'Maglio'
  end

  it 'onlu owner can delete subject' do
    user = User::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    user.success?.must_equal true
    user2 = User::Create.(email: 'tes2t@email.com', password: 'password', confirm_password: 'password')

    subject = Subject::Create.({
                                 user_id: user['model'].id,
                                 firstname: 'Ema',
                                 lastname: 'Maglio',
                                 gender: 'Male',
                                 dob: '01/01/1980',
                                 height: '180',
                                 weight: '80',
                                 phone: '912873',
                                 email: 'ema@email.com'
                               }, 'current_user' => user)
    subject.success?.must_equal true

    upload_file = ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join('test/files/cpet.xlsx'))
    )

    report = Report::Create.({
                               user_id: user['model'].id,
                               subject_id: subject['model'].id,
                               title: 'My report',
                               cpet_file_path: upload_file,
                               template: 'default'
                             }, 'current_user' => user['model'])
    report.success?.must_equal true

    assert_raises ApplicationController::NotAuthorizedError do
      Subject::Delete.(
        { id: subject['model'].id },
        'current_user' => user2['model']
      )
    end

    result = Subject::Delete.({ id: subject['model'].id }, 'current_user' => user['model'])
    result.success?.must_equal true
    Subject.where('id like ?', subject['model'].id).size.must_equal 0
    Report.where('subject_id like ?', subject['model'].id).size.must_equal 0
  end

  it 'edit height and weight' do
    user = User::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    user.success?.must_equal true
    user2 = User::Create.(email: 'tes2t@email.com', password: 'password', confirm_password: 'password')

    subject = Subject::Create.({
                                 user_id: user['model'].id,
                                 firstname: 'Ema',
                                 lastname: 'Maglio',
                                 gender: 'Male',
                                 dob: '01/01/1980',
                                 height: '180',
                                 weight: '80',
                                 phone: '912873',
                                 email: 'ema@email.com'
                               }, 'current_user' => user)
    subject.success?.must_equal true

    assert_raises ApplicationController::NotAuthorizedError do
      Subject::EditHeightWeight.(
        {
          id: subject['model'].id,
          height: '180',
          weight: '80'
        },
        'current_user' => user2['model']
      )
    end

    result = Subject::EditHeightWeight.(
      { id: subject['model'].id, height: '200', weight: '100' },
      'current_user' => user['model']
    )
    result.success?.must_equal true
    result['model'].height.must_equal 200
    result['model'].weight.must_equal 100
  end
end
