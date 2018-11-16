#!/usr/bin/env ruby

# Navigate to the root of your project directory and run this script. It will
# create a branch called "backup" and randomly (every 20-30 minutes) switch to,
 # stage and commit all of your changes (unless they are added to your .gitignore).
# It will then switch back to your current branch.

def check_branch

  branches = %x(git branch)
  branches_array = branches.split("\n")

  branches_array.each do |each|
    branch = each.split(" ")
    if branch.include?("*")
      branch = branch - ["*"]
      branch = branch.join
      puts "current branch = " + branch
      return branch
    end
  end
end


def backup()
  time_instance = Time.now.to_i.to_s

  puts "--------------------------------------------------------------"
  puts "BACKING UP ---------------------------------------------------"
  puts "BACKUP ID = " + time_instance
  previous_branch = check_branch
  puts "previous branch: " + previous_branch
  puts "next branch ID: " + time_instance
  system("git checkout -b backup-#{time_instance} &&  git add . && git commit -m \"automated backup: ID = #{time_instance}\" && git checkout #{previous_branch} && git merge backup-#{time_instance}")
  system("git checkout #{previous_branch}")
  puts "backup complete"
  puts "returning to: " + previous_branch
  puts "--------------------------------------------------------------"
end

# on first run, determine current branch, create backup branch, add commit,
# then switch back to previous branch

while true
  # generate random number of minutes between 10 and 20
  # backup_interval = 600 + (Math.random * 60 * 20)
  backup
  backup_interval = 5 + rand(5)
  sleep(backup_interval)
end
