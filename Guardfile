guard :minitest, autorun: true, bundler: true, test_folders: ['test'] do
    watch(%r{^test/test_(.*)\.rb$})
    watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { |m| "test/test_#{m[2]}.rb" }
    watch(%r{^test/test_helper\.rb$})  { 'test' }
#    watch('templates/status-plugin.js.tt') { 'test/test_status_plugin.rb' }
end
