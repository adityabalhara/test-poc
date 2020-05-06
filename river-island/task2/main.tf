module "ecrpolicy" {
  source = "./module"
  reponame = var.reponame
#  reponame = ["testecr","demoecr"]
}
