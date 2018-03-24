# cookbook-wpmanager

TODO: Enter the cookbook description here.

## dna.json
The following json is expected to be passed to `sudo chef-solo -c solo.rb -j <dna.json>`
```
{"wp":{
        "sites":["example.com","example2.com"],
        "mysql":{
                "password": ""
        },
        "amplify": {
                "enable": false,
                "key": "b0455458fc4d524116ad95eba8afad90",
                "config": {
                        "hostname": "",
                        "mysqlpass":""
                }
        }
},
"run_list":["recipe[wpmanager::default]"]}
```
