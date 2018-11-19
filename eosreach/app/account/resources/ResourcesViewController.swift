import UIKit
import RxSwift
import RxCocoa

class ResourcesViewController: MxViewController<ResourcesIntent, ResourcesResult, ResourcesViewState, ResourcesViewModel>, ResourcesViewLayout {
    
    @IBOutlet weak var manageResources: UILabel!
    @IBOutlet weak var bandwidthButton: ReachButton!
    @IBOutlet weak var ramButton: ReachButton!
    @IBOutlet weak var ramResourceGraph: ResourceGraphView!
    @IBOutlet weak var cpuResourceGraph: ResourceGraphView!
    @IBOutlet weak var netResourceGraph: ResourceGraphView!
    
    var readOnly = false
    var eosAccount: EosAccount?
    
    private lazy var resourcesRenderer: ResourcesRenderer = {
        return ResourcesRenderer(layout: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageResources.text = R.string.accountStrings.account_resources_title()
        bandwidthButton.setTitle(R.string.accountStrings.account_resources_bandwidth_button(), for: .normal)
        ramButton.setTitle(R.string.accountStrings.account_resources_ram_button(), for: .normal)
        
        if (readOnly) {
            manageResources.gone()
            bandwidthButton.gone()
            ramButton.gone()
        }
    }

    override func intents() -> Observable<ResourcesIntent> {
        return Observable.merge(
            Observable.just(ResourcesIntent.start(eosAccount: eosAccount!)),
            bandwidthButton.rx.tap.map {
                return ResourcesIntent.navigateToManageBandwidth
            },
            ramButton.rx.tap.map {
                return ResourcesIntent.navigateToManageRam
            }
        )
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
            print("")
        case .navigateToManageBandwidthWithAccountName:
            print("")
        case .navigateToManageRam:
            print("")
        case .refundProgress:
            print("")
        case .refundSuccess:
            print("")
        case .refundFailed:
            print("")
        case .refundFailedWithLog(let log):
            print("")
        }
    }

    override func provideViewModel() -> ResourcesViewModel {
        return ResourcesViewModel(initialState: ResourcesViewState.idle)
    }
    
    func emptyStakedResources() {
    }
    
    func populateNetStake(formattedBalance: String) {
        
    }
    
    func emptyNetStake() {
        
    }
    
    func populateCpuStake(formattedBalance: String) {
        
    }
    
    func emptyCpuStake() {
        
    }
    
    func emptyDelegatedResources() {
        
    }
    
    func populateNetDelegated(formattedBalance: String) {
        
    }
    
    func emptyNetDelegated() {
        
    }
    
    func populateCpuDelegated(formattedBalance: String) {
        
    }
    
    func emptyCpuDelegated() {
        
    }
    
    func emptyRefundRequest() {
        
    }
    
    func populateRefundRequest(formattedNet: String, formattedCpu: String) {
        
    }
    
    func populate(eosAccount: EosAccount) {
        renderResourceGraphView(
            resourceGraphView: ramResourceGraph,
            titleLabel: R.string.accountStrings.account_resources_ram_graph_title(),
            usageLabel: "",
            resource: eosAccount.ramResource,
            graphColor: R.color.colorAccent()!)
        
        renderResourceGraphView(
            resourceGraphView: cpuResourceGraph,
            titleLabel: R.string.accountStrings.account_resources_cpu_graph_title(),
            usageLabel: "",
            resource: eosAccount.cpuResource,
            graphColor: R.color.colorAccent()!)
        
        renderResourceGraphView(
            resourceGraphView: netResourceGraph,
            titleLabel: R.string.accountStrings.account_resources_net_graph_title(),
            usageLabel: "",
            resource: eosAccount.netResource,
            graphColor: R.color.colorAccent()!)
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
    
    private func resourceRemaining(resource: EosAccountResource) -> Int64 {
        return resource.available - resource.used
    }
    
    private func resourcePercentage(resource: EosAccountResource) -> Float {
        if (resource.used <= 0) {
            return 100
        } else if (resource.available == resource.used) {
            return 0
        } else {
            let remaining = Float(resource.available) - Float(resource.used)
            return (remaining * 100) / Float(resource.available)
        }
    }
}
