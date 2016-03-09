namespace :unicorn do
  desc "Start unicorn for #{ENV['RAILS_ENV']} env."
  task(:start) {
    config = Rails.root.join('config', 'unicorn.rb')
    sh "bundle exec unicorn_rails -c #{config} -E #{ENV['RAILS_ENV']} -D"
  }

  desc "Stop unicorn"
  task(:stop) { unicorn_signal :QUIT }

  desc "Restart unicorn with USR2"
  task(:restart) { unicorn_signal :USR2 }

  desc "Increment number of worker processes"
  task(:increment) { unicorn_signal :TTIN }

  desc "Decrement number of worker processes"
  task(:decrement) { unicorn_signal :TTOU }

  desc "Unicorn pstree (depents on pstree command)"
  task(:pstree) do
    sh "pstree '#{unicorn_pid}'"
  end


  def unicorn_signal signal
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    begin
      File.read("/var/tmp/unicorn.pid").to_i
    rescue Errno::ENOENT
      raise "Unicorn doesn't seem to be running or PID file doesn't exist"
    end
  end

end
