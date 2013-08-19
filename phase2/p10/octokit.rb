require 'octokit'
require 'thor'

class OctoView < Thor

  desc 'show_user USERNAME', 'show some info about the user'
  def show_user(username = 'octokit')
    user = Octokit.user username
    puts "login #{user.login}"
    puts "email: #{user.email}"
    puts "avatar: #{user.avatar_url}"
  end

  desc 'stargazers_for REPO_NAME', 'show the stargazers of REPO_NAME'
  def stargazers_for(repo_name = 'octokit/octokit.rb')
    stargazers = Octokit.stargazers(repo_name)
    stargazers.map!(&:login)
    puts stargazers
  end

  desc 'tags_of REPO_NAME', 'show the tags of REPO_NAME'
  def tags_of(repo_name = 'octokit/octokit.rb')
    tags = Octokit.tags(repo_name)
    tags.map!(&:name)
    puts tags
  end
end

OctoView.start(ARGV)
