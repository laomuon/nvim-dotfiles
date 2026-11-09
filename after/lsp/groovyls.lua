return {
    cmd = {"java", "-jar", os.getenv("HOME") .. "/groovy-language-server/build/libs/groovy-language-server-all.jar"},
    filetypes = {"groovy", "Jenkinsfile"},
}
