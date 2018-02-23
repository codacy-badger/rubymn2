require 'test_helper'

class ProjectEditTest < ActionDispatch::IntegrationTest
  def check_no_edit_button
    visit project_path(@p2)
    assert page.has_no_link?('Edit Project', href: project_path(@p2))
  end

  test 'visitor may not edit project' do
    check_no_edit_button
  end

  test 'wrong user may not edit project' do
    login_as(@u2, scope: :user)
    check_no_edit_button
  end

  test 'correct user gets button to edit project' do
    login_as(@u3, scope: :user)
    visit project_path(@p2)
    assert page.has_link?('Edit Project', href: edit_project_path(@p2))
  end

  test 'regular admin may not edit project' do
    login_as(@a4, scope: :admin)
    check_no_edit_button
  end

  test 'super admin may not edit project' do
    login_as(@a1, scope: :admin)
    check_no_edit_button
  end

  test 'correct user can successfully edit project' do
    login_as(@u3, scope: :user)
    visit edit_project_path(@p2)

    assert page.has_css?('title', text: full_title('Edit Project'),
                                  visible: false)
    fill_in('Title', with: 'A View To A Kill')
    fill_in('Source Code URL', with: 'https://github.com/rmoore/avtak')
    fill_in('Deployed URL', with: 'http://www.aviewtoakill.com')
    fill_in('Description', with: 'Investigate Zorin Industries')
    click_button('Submit')

    assert page.has_css?('title',
                         text: full_title('Project: A View To A Kill'),
                         visible: false)
    assert page.has_css?('h1', text: 'Project: A View To A Kill')
    assert_text 'Investigate Zorin Industries'
    assert page.has_link?('https://github.com/rmoore/avtak',
                          href: 'https://github.com/rmoore/avtak')
    assert page.has_link?('http://www.aviewtoakill.com',
                          href: 'http://www.aviewtoakill.com')
  end
end
