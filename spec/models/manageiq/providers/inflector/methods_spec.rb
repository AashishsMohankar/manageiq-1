describe ManageIQ::Providers::Inflector::Methods do
  context "#provider_name" do
    it "returns name for an instance" do
      manager = ManageIQ::Providers::Alibaba::CloudManager.new
      expect(manager.provider_name).to eq('Alibaba')
    end

    it "returns name for a class" do
      manager = ManageIQ::Providers::Alibaba::CloudManager
      expect(manager.provider_name).to eq('Alibaba')
    end

    it "returns name for a vm" do
      vm = ManageIQ::Providers::Alibaba::CloudManager::Vm.new
      expect(vm.provider_name).to eq('Alibaba')
    end
  end
end
