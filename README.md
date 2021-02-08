# aws manager scripts

## settings
1. ruby install
2. bundle install
3. aws configuration

### ruby install
https://qiita.com/hujuu/items/3d600f2b2384c145ad12

install ruby version -> 2.6.5

### bundle install
```
$ >> gem install bundler
$ >> bundle install --path vendor/bundle
```

### aws configuration
https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_use_switch-role-cli.html
各環境ごとにプロファイルを作るとよし


## usage
```
(master) $ >> bundle exec rake profile=awspre -T
rake create:image:all  # create images
rake get:dynamo        # get item
rake get:ec2_list      # get ec2 list
rake get:name          # get names
rake get:record_list   # get record list
rake search:ip         # get names

(master) $ >> bundle exec rake profile=awspre name=pbat get:name
pre1-pbat1
pre2-pbat1
pre3-pbat1
```
