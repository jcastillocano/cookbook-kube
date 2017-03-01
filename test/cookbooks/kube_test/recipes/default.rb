# Client

remote_file 'kubectl binary' do
  path '/usr/bin/kubectl'
  mode '0755'
  source 'https://storage.googleapis.com/kubernetes-release/release'\
         '/v1.2.4/bin/linux/amd64/kubectl'
  checksum 'dac61fbd506f7a17540feca691cd8a9d9d628d59661eebce788a50511f578897'
end

# Master

etcd_service 'default' do
  source 'http://github.com/coreos/etcd/releases/download'\
         '/v2.2.3/etcd-v2.2.3-linux-amd64.tar.gz '
  version '2.2.3'
  service_manager 'systemd'
  action %w(create start)
end # Needed by the kube_apiserver[default]

kube_apiserver 'default' do
  service_cluster_ip_range '10.0.0.1/24'
  etcd_servers 'http://127.0.0.1:4001'
  insecure_bind_address '0.0.0.0' # for convenience
  action %w(create start)
end

group 'docker' do
  members %w(kubernetes)
end

kube_scheduler 'default' do
  action %w(create start)
end

kube_controller_manager 'default' do
  action %w(create start)
end

# Node
case node['platform_family']
when 'debian'
  include_recipe 'apt'

  node['docker']['repository'].tap do |repo|
    apt_repository repo['name'] do
      uri repo['uri']
      distribution repo['distro']
      components repo['components']
      keyserver repo['keyserver']
      key repo['key']
      cache_rebuild repo['cache_rebuild']
    end
  end
when 'rhel'
  node['docker']['repository'].tap do |repo|
    yum_repository repo['name'] do
      enabled repo['enabled']
    end
  end
else raise("Platform family #{node['platform_family']} not supported")
end

flannel_service 'default' do
  configuration 'Network' => '10.10.0.1/16'
  action %w(create configure start)
end.extend FlannelCookbook::SubnetParser

directory '/etc/kubernetes/manifests' do
  recursive true
end

docker_install_method = node['docker']['install_method']
docker_service 'default' do
  bip lazy { resources('flannel_service[default]').subnetfile_subnet }
  mtu lazy { resources('flannel_service[default]').subnetfile_mtu }
  install_method docker_install_method unless docker_install_method.nil?

  http_proxy node['proxy']['http'] unless node['proxy']['http'].nil?
  https_proxy node['proxy']['https'] unless node['proxy']['https'].nil?
  no_proxy node['proxy']['no_proxy'] unless node['proxy']['no_proxy'].nil?
  version node['docker']['version'] unless node['docker']['version'].nil?
end # needed by kubelet_service[default]

kubelet_service 'default' do
  api_servers 'http://127.0.0.1:8080'
  config '/etc/kubernetes/manifests'
  cluster_dns '10.0.0.10'
  cluster_domain 'cluster.local'
  action %w(create start)
end

package 'ethtool' # needed by the kubelet

kube_proxy 'default' do
  action %w(create start)
end

# test running a sample pod

t = template '/etc/kubernetes/manifests/busybox.yaml'

execute 'kubectl create -f /etc/kubernetes/manifests/busybox.yaml' do
  action :nothing
  subscribes :run, "template[#{t.name}]", :immediately
end
