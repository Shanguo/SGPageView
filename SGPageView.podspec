Pod::Spec.new do |s|
s.name = 'SGPageView'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'An pageView component where can scroll tableView.'
s.homepage = 'https://github.com/shanguo/SGPageView'
s.authors = { '刘山国' => '857363312@qq.com' }
s.source = { :git => 'https://github.com/shanguo/SGPageView.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'SGPageViewTest/SGPageView/*.{h,m}'
s.resources = ['SGPageViewTest/*.xib', 'SGPageViewTest/*.xcassets']
end
