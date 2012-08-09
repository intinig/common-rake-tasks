# Common Rake tasks

This is a repository (hopefully a growing one) that contains common rake tasks that I stuff in my ~/.rake directory to be available globally.

## Haml

```
  rake haml:watch SOURCE=source_folder DEST=destination_folder
```

A simple haml watcher that monitors source_folder for any type of change to .haml files and compiles them to .html in destination_folder.