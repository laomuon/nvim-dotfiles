-- ltex (language-tool)
return {
    settings = {
        ltex = {
            -- dictionary = {
            --   ['en-US'] = {'embb', 'urllc', 'mmtc', 'Duc', 'mIoT', 'MIoT', 'MEAR', 'GeCode', 'VNF-FGE', 'QoS', 'Qos', 'gNB', 'gNBs', 'MILP'}
            -- }
            enabled = true,
            language = "en-GB",
            languageToolOrg = {
                username = os.getenv("LGT_USERNAME"),
                apiKey = os.getenv("LGT_KEY"),
            },
            languageToolHttpServerUri = "https://api.languagetoolplus.com",
            checkFrequency = "save",
            -- additionalRules = {
            --      languageModel = '~/ngrams/',
            --    },
        },
    },
    filetypes = {"tex", "bib"},
}
