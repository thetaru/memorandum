## 変数の受け渡し
```rb
namespace :task_name do
  task :task_test, ['name'] do |task, args|
    puts args[:name]
    puts args.name
  end
end
```
```sh
rake task_name:task_test["name"]
```

## 順序をつける方法
```rb
namespace :task_name do
  task main_task: :pre_task do
    puts 'This is a main task.'
  end
  
  task :pre_task do
    puts 'This is a pre task.'
  end
end
```
```sh
rake task_name:main_task
```
