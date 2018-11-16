#!/usr/bin/env ruby

# Navigate to the root of your project directory and run this script. It will
# create a branch called "backup" every 20-30 minutes (exact time is randomized),
# then it will switch to it, stage and commit all of your changes (unless they are added to
# your .gitignore), then switch back to your previous branch, merge it and delete the
# backup branch. This should maintain a consistent backup schedule without encountering
# any merge conflicts.

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

  puts "--------------------------------------------------------------"
  puts "BACKING UP ---------------------------------------------------"
  previous_branch = check_branch
  puts "previous branch: " + previous_branch
  system("git checkout -b backup &&  git add . && git commit -m \"automated backup fail-safe\" && git checkout #{previous_branch} && git merge backup")
  system("git checkout #{previous_branch}")
  puts "backup complete"
  puts "removing backup branch"
  system("git branch -D `git branch | grep -E 'backu*'`")
  puts "backup branch cleaned"
  puts "returning to: " + previous_branch
  puts "--------------------------------------------------------------"

end

# User inputs a number of minutes as an interval for commit backups
puts "Please enter an approximate backup_interval (in minutes)."
puts "Your commits will occur between 100% and 75% of your backup_interval."

desired_interval_in_minutes = gets.chomp.to_i

while true
  backup()
  backup_interval = (desired_interval_in_minutes * 3/4 * 60) + (rand(desired_interval_in_minutes) * 1/4 * 60)
  sleep(backup_interval)
end
