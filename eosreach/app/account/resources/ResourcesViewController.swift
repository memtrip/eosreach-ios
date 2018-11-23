import UIKit
import RxSwift
import RxCocoa
import eosswift

class ResourcesViewController: MxViewController<ResourcesIntent, ResourcesResult, ResourcesViewState, ResourcesViewModel>, ResourcesViewLayout {
    
    @IBOutlet weak var manageResources: UILabel!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var bandwidthButton: ReachButton!
    @IBOutlet weak var ramButton: ReachButton!
    @IBOutlet weak var ramResourceGraph: ResourceGraphView!
    @IBOutlet weak var cpuResourceGraph: ResourceGraphView!
    @IBOutlet weak var netResourceGraph: ResourceGraphView!
    @IBOutlet weak var stakedLabel: UILabel!
    @IBOutlet weak var stakedReachNetCpuView: ReachNetCpuView!
    @IBOutlet weak var delegatedLabel: UILabel!
    @IBOutlet weak var delegatedNetCpuView: ReachNetCpuView!
    @IBOutlet weak var refundLabel: UILabel!
    @IBOutlet weak var refundNetCpuView: ReachNetCpuView!
    
    var readOnly = false
    var eosAccount: EosAccount?
    var contractAccountBalance: ContractAccountBalance?
    
    private lazy var resourcesRenderer: ResourcesRenderer = {
        return ResourcesRenderer(layout: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageResources.text = R.string.accountStrings.account_resources_title()
        bandwidthButton.setTitle(R.string.accountStrings.account_resources_bandwidth_button(), for: .normal)
        ramButton.setTitle(R.string.accountStrings.account_resources_ram_button(), for: .normal)
        stakedLabel.text = R.string.accountStrings.account_resources_staked_title()
        delegatedLabel.text = R.string.accountStrings.account_resources_delegated_title()
        refundLabel.text = R.string.accountStrings.account_resources_refund_title()
        
        if (readOnly) {
            manageResources.removeFromSuperview()
            buttonContainer.removeFromSuperview()
        }
    }

    override func intents() -> Observable<ResourcesIntent> {
        return Observable.merge(
            Observable.just(ResourcesIntent.start(eosAccount: eosAccount!)),
            unwrapBandwidthButton(),
            unwrapRamButton()
        )
    }
    
    private func unwrapBandwidthButton() -> Observable<ResourcesIntent> {
        if (readOnly) {
            return Observable.empty()
        } else {
            return bandwidthButton.rx.tap.map {
                return ResourcesIntent.navigateToManageBandwidth
            }
        }
    }
    
    private func unwrapRamButton() -> Observable<ResourcesIntent> {
        if (readOnly) {
            return Observable.empty()
        } else {
            return ramButton.rx.tap.map {
                return ResourcesIntent.navigateToManageRam
            }
        }
    }

    override func idleIntent() -> ResourcesIntent {
        return ResourcesIntent.idle
    }

    override func render(state: ResourcesViewState) {
        switch state {
        case .idle:
            print("")
        case .populate(let eosAccount):
            resourcesRenderer.render(eosAccount: eosAccount)
        case .navigateToManageBandwidth:
            performSegue(withIdentifier: R.segue.resourcesViewController.resourcesToManageBandwidth, sender: self)
        case .navigateToManageBandwidthWithAccountName:
            print("")
        case .navigateToManageRam:
            setDestinationBundle(bundle: SegueBundle(
                identifier: R.segue.resourcesViewController.resourcesToManageRam.identifier,
                model: ManageRamBundle(contractAccountBalance: contractAccountBalance!, costPerKb: nil)
            ))
            performSegue(withIdentifier: R.segue.resourcesViewController.resourcesToManageRam, sender: self)
        }
    }

    override func provideViewModel() -> ResourcesViewModel {
        return ResourcesViewModel(initialState: ResourcesViewState.idle)
    }
    
    func emptyStakedResources() {
        stakedLabel.removeFromSuperview()
        stakedReachNetCpuView.removeFromSuperview()
    }
    
    func populateNetStake(formattedBalance: String) {
        stakedReachNetCpuView.netValueLabel.text = formattedBalance
    }
    
    func emptyNetStake() {
        stakedReachNetCpuView.netValueLabel.text = R.string.appStrings.app_empty_value()
    }
    
    func populateCpuStake(formattedBalance: String) {
        stakedReachNetCpuView.cpuValueLabel.text = formattedBalance
    }
    
    func emptyCpuStake() {
        stakedReachNetCpuView.cpuValueLabel.text = R.string.appStrings.app_empty_value()
    }
    
    func emptyDelegatedResources() {
        delegatedLabel.removeFromSuperview()
        delegatedNetCpuView.removeFromSuperview()
    }
    
    func populateNetDelegated(formattedBalance: String) {
        delegatedNetCpuView.netValueLabel.text = formattedBalance
    }
    
    func emptyNetDelegated() {
        delegatedNetCpuView.netValueLabel.text = R.string.appStrings.app_empty_value()
    }
    
    func populateCpuDelegated(formattedBalance: String) {
        delegatedNetCpuView.cpuValueLabel.text = formattedBalance
    }
    
    func emptyCpuDelegated() {
        delegatedNetCpuView.cpuValueLabel.text = R.string.appStrings.app_empty_value()
    }
    
    func emptyRefundRequest() {
        refundLabel.removeFromSuperview()
        refundNetCpuView.removeFromSuperview()
    }
    
    func populateRefundRequest(formattedNet: String, formattedCpu: String) {
        refundNetCpuView.netValueLabel.text = formattedNet
        refundNetCpuView.cpuValueLabel.text = formattedCpu
    }
    
    func populate(eosAccount: EosAccount) {
        
        renderResourceGraphView(
            resourceGraphView: ramResourceGraph,
            titleLabel: R.string.accountStrings.account_resources_ram_graph_title(),
            usageLabel: "\(Pretty.ram(value: resourceRemaining(resource: eosAccount.ramResource))) / \(Pretty.ram(value: Float(eosAccount.ramResource.available)))",
            resource: eosAccount.ramResource,
            graphColor: R.color.resourcesRamColor()!)
        
        renderResourceGraphView(
            resourceGraphView: cpuResourceGraph,
            titleLabel: R.string.accountStrings.account_resources_cpu_graph_title(),
            usageLabel: "\(Pretty.cpu(value: resourceRemaining(resource: eosAccount.cpuResource))) / \(Pretty.cpu(value: Float(eosAccount.cpuResource.available)))",
            resource: eosAccount.cpuResource,
            graphColor: R.color.resourcesCpuColor()!)
        
        renderResourceGraphView(
            resourceGraphView: netResourceGraph,
            titleLabel: R.string.accountStrings.account_resources_net_graph_title(),
            usageLabel: "\(Pretty.net(value: resourceRemaining(resource: eosAccount.netResource))) / \(Pretty.net(value: Float(eosAccount.netResource.available)))",
            resource: eosAccount.netResource,
            graphColor: R.color.resourcesNetColor()!)
    }
    
    private func renderResourceGraphView(
        resourceGraphView: ResourceGraphView,
        titleLabel: String,
        usageLabel: String,
        resource: EosAccountResource,
        graphColor: UIColor
    ) {
        resourceGraphView.populate(
            titleLabelValue: titleLabel,
            usageLabelValue: usageLabel,
            percentage: resourcePercentage(resource: resource),
            graphColor: graphColor
        )
    }
    
    private func resourceRemaining(resource: EosAccountResource) -> Float {
        return Float(resource.available) - Float(resource.used)
    }
    
    private func resourcePercentage(resource: EosAccountResource) -> Float {
        if (resource.used <= 0) {
            return 1
        } else if (resource.available == resource.used) {
            return 0
        } else {
            let remaining = resourceRemaining(resource: resource)
            return (remaining * 100) / Float(resource.available)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == R.segue.resourcesViewController.resourcesToManageBandwidth.identifier) {
            (segue.destination as! ManageBandwidthViewController).manageBandwidthBundle = ManageBandwidthBundle(
                accountName: eosAccount!.accountName, contractAccountBalance: contractAccountBalance!)
        }
    }
}
