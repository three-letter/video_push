#! /bin/bash
export PATH='/Users/halsey/.rvm/rubies/ruby-1.9.3-head/bin':$PATH
cd /Users/halsey/work/rails/my_app/video_push && /Users/halsey/.rvm/rubies/ruby-1.9.3-head/bin/rake spider:youku >> /Users/halsey/work/rails/my_app/video_push/log/shell.log 2>&1
