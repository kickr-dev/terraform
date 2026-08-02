#####################################################
#
# Locals
#
#####################################################

locals {
  domain = "kickr.dev"

  branch_name_regex    = "^(alpha|beta|dev|develop|main|next|rc|staging|v[0-9]+(\\.[0-9]+)?\\.x|(chore|docs|feat|fix|kickr|release|renovate)\\/\\S+)$"
  commit_message_regex = "^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\\(.+\\))?(!)?:\\s.+"

  descriptions = {
    kickr    = "Kickr token to create branches and pull requests for kickr layout maintainance purposes"
    release  = "Release token to create releases on GitLab, push commit(s) for version files and comment on issues and pull requests"
    renovate = "Renovate token to create branches and pull requests for versions maintainance purposes"
  }

  schedulers = {
    renovate = {
      active   = true
      schedule = "0 12 * * 5"
    }

    kickr = {
      active   = false
      schedule = "0 12 * * 6"
    }
  }

  labels = [
    {
      color       = "#D73A4A"
      description = "Something isn't working"
      name        = "bug"
    },
    {
      color       = "#0366D6"
      description = "This was made by dependabot"
      name        = "dependabot"
    },
    {
      color       = "#0052CC"
      description = "Updates some dependencies"
      name        = "dependencies"
    },
    {
      color       = "#0075CA"
      description = "Improvements or additions to documentation"
      name        = "documentation"
    },
    {
      color       = "#CFD3D7"
      description = "This issue or pull request already exists"
      name        = "duplicate"
    },
    {
      color       = "#A2EEEF"
      description = "New feature or request"
      name        = "enhancement"
    },
    {
      color       = "#7057FF"
      description = "Good for newcomers"
      name        = "good first issue"
    },
    {
      color       = "#008672"
      description = "Extra attention is needed"
      name        = "help wanted"
    },
    {
      color       = "#E4E669"
      description = "This doesn't seem right"
      name        = "invalid"
    },
    {
      color       = "#09AD9D"
      description = "This was made by kickrbot"
      name        = "kickr"
    },
    {
      color       = "#B60205"
      description = "A major dependency update"
      name        = "major"
    },
    {
      color       = "#D876E3"
      description = "Further information is requested"
      name        = "question"
    },
    {
      color       = "#EDEDED"
      description = "Indicates that a pull request or issue has been released"
      name        = "released"
    },
    {
      color       = "#5319E7"
      description = "This was made by renovatebot"
      name        = "renovate"
    },
    {
      color       = "#D93F0B"
      description = "Improvements or additions to testcases"
      name        = "test"
    },
    {
      color       = "#D4C5F9"
      description = "This will not be worked on"
      name        = "wontfix"
    }
  ]

  secrets = {
    git = yamldecode(data.sops_file.git.raw)
  }
}

#####################################################
#
# Sops
#
#####################################################

ephemeral "sops_file" "providers" {
  source_file = ".providers.enc.yml"
  input_type  = "yaml"
}

data "sops_file" "git" {
  source_file = ".git.enc.yml"
  input_type  = "yaml"
}
