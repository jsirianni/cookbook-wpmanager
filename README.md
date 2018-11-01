# cookbook-wpmanager

TODO: Enter the cookbook description here.

## dna.json
The following json is expected to be passed to `sudo chef-solo -c solo.rb -j <dna.json>`
```
{"wp":{
        "sites":["example.com","example2.com"],
        "mysql":{
                "password": ""
        }
},
"run_list":["recipe[wpmanager::default]"]}
```
