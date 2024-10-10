//
//  ProfileVC.swift
//  inTouch
//
//  Created by Admin on 7/30/21.
//

import UIKit

import PagingKit
import Kingfisher
import SpeedLog

enum OpenProfileType: Int {
    case userProfile = 0
    case petProfile = 1
}
class ProfileVC: UIViewController {
    
    @IBOutlet weak var topContentView: UIView!
    
    @IBOutlet var topView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backArrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var previewView: UIView!
    
    
    
    @IBOutlet weak var heightOfPageContainer: NSLayoutConstraint!
    @IBOutlet weak var gradiantView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    @IBOutlet weak var userInfoView: UIView!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var moodView: UIView!
    
    @IBOutlet weak var subScriptionView: UIView!
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var ageAndGenderLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var moodTitleLabel: UILabel!
    
    @IBOutlet weak var moodTypeLabel: UILabel!
    
    @IBOutlet weak var changeMoodSwitch: UISwitch!
    
    @IBOutlet weak var subscriptionTitleLabel: UILabel!
    
    @IBOutlet weak var subscriptionTypeLable: UILabel!
    
    
    
    
    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var updateTextLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    var menuViewController : PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    var position: Int = 0
    var sideDelegate: UpdateSideMenuDataDelegate?
    var settingViewHeight = 0.0
    var editViewHeight = 0.0
    let mainLineView = UIView()
    let focusView = UINib(nibName: "UnderLineView", bundle: nil)
    let userId = userDefault.integer(forKey: CURRENTUSERID)
    
    static var sizingCell = TitleLabelMenuViewCell(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    let focusLineViewHeightConstraint:CGFloat = 2.0
    let focusLineViewCornerRedius:CGFloat = 5.5
    let focusCellTextColor:UIColor = .AppWhiteColour
    let betweenMenuCellSpacing:CGFloat = 0.0
    let CategoryAry = ["My Profile","My Settings"]
    lazy var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    
    var dataSource = [(menuTitle: String, vc: UIViewController)]()
    var petDataSource = [(menuTitle: String, vc: UIViewController)]()
    
    
    private var scrollDirection = UICollectionView.ScrollDirection.horizontal
    let gradientLayer = CAGradientLayer()
    let effectView = UIVisualEffectView()
    
    
    var isFromPetProfile:Bool = false
    var isForOpenSetting: Bool = false
    var indexValue : Int = 0
    
    var viewModel = UserProfileVM()
    var userModel: UsereProfileModel?
    var petProfileModel : PetProfileModel?
    var onBoardingViewModel = onBoardingVM()
    var petOnBoardingViewModel = PetOnboardingVM()
    var postURL : String?
    var petOnboardingID : Int?
    var postArrayObject: [PostResultModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpImageData()
        setPageDataSource(type: isFromPetProfile ? .petProfile : .userProfile)
        setUpViewModel()
        addTopFade(frame: gradiantView.bounds)
        DispatchQueue.main.async {
            self.setUpDetailsView()
        }
        self.setSeqment()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToHome), name: Notification.Name("GoToHome"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @objc func goToHome(notification: Notification){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.navigationController?.backToViewController(vc: OtherUserVC.self)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setPageDataSource(type: OpenProfileType){
        let editVC = loadViewController(Storyboard: Storyboards.Profile, ViewController: ViewControllers.EditProfileVC) as! EditProfileVC
        editVC.isFromPetProfile = type
        editVC.petOnboardingID = petOnboardingID
        editVC.profilePosition = position
        editVC.changeHeightDelegate = self
        
        let settingVC = loadViewController(Storyboard: Storyboards.Profile, ViewController: ViewControllers.MySettingVC) as! MySettingVC
        settingVC.isFromPetProfile = type
        settingVC.petOnboardingID = petOnboardingID
        settingVC.changeHeightDelegate = self
        settingVC.position = position
        settingVC.sideDelegate = sideDelegate
        if type == .userProfile{
            dataSource = [(menuTitle: "Profile", vc: editVC),(menuTitle: "Settings", vc: settingVC)]
        }else{
            // moodView.isHidden = true
            petDataSource = [(menuTitle: "Profile", vc: editVC),(menuTitle: "Settings", vc: settingVC)]
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    private func setUpViewModel(){
        viewModel.delegate = self
        if isFromPetProfile {
            viewModel.getPetProfileDataByPetOnBoardingIdApiCall(petOnBoardingID: petOnboardingID ?? 0)
        }else{
            viewModel.getProfileDataApiCall(userId: userId)
        }
    }
    
    private func setUpProfileData() {
        
        subscriptionTitleLabel.text = "\(userDefault.string(forKey: SubscritpionTypeName) ?? "") · \(userDefault.string(forKey: SubscriptionDurationName) ?? "")"
        let dateFormater = DateFormatter()
        let expiredDateString = userDefault.string(forKey: SubscriptionExpireDate) ?? ""
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateOfBirth = dateFormater.date(from: expiredDateString)
        dateFormater.dateFormat = "d MMM yyyy"
        subscriptionTypeLable.text = expiredDateString == "" ? "My subscriptions" : "Next Renewal on \(dateFormater.string(from: dateOfBirth ?? Date()))"
        if isFromPetProfile {
            if let data = petProfileModel?.result?[0] {
                userNameLabel.text = "\(data.petName ?? "")"
                moodTypeLabel.text = ProfileTypeEnum.init(rawValue: (data.petProfileType ?? 0)-1)?.type()
                let age = findAge(date: data.petDob ?? "")
                ageAndGenderLabel.text = "\(age)"
            }
        }else {
            if let data = userModel?.result?[0]{
                userNameLabel.text = "\(data.userInfo?[0].username ?? "")"
                moodTypeLabel.text = ProfileTypeEnum.init(rawValue: (data.profileType ?? 0)-1)?.type()
                let age = findAge(date: data.dateOfBirth ?? "")
                ageAndGenderLabel.text = "\(age)"
            }
        }
    }
    
    func findAge(date : String) -> Int{
         let birthday = dateFormatter.date(from: date)
        guard let timeInterval = birthday?.timeIntervalSinceNow else { return 0 }
        let age = abs(Int(timeInterval / 31556926.0))
        return age
    }
    
    private func SetUpImageData(){
        userImageView.kf.indicatorType = .activity
        (userImageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .AppAquaColour
        userImageView.kf.setImage(with: URL(string: "\(APIServerConstants.imageBaseURL)\(postURL ?? "")"),options: [.transition(.fade(0.7))])
    }
    func setUpDetailsView() {
        DispatchQueue.main.async {
            self.backView.cornerRadius = self.backView.frame.height/2
            self.titleLabel.text = self.isFromPetProfile ? "MY PET PROFILE" : "MY PROFILE"
        }
        userInfoView.layer.cornerRadius = 14
        userInfoView.layer.masksToBounds = true
        let blurEffect = UIBlurEffect(style: .dark)
        effectView.effect = blurEffect
        self.effectView.frame = self.userInfoView.bounds
        updateView.addShadowInDiffrentWay(shadowColor: .AppAquaColour, offSet: CGSize(width: 0, height: 2), opacity: 0.2, shadowRadius: 8)
        previewView.addShadowInDiffrentWay(shadowColor: .AppAquaColour, offSet: CGSize(width: 0, height: 2), opacity: 0.2, shadowRadius: 8)
        DispatchQueue.main.async {
            self.userInfoView.addSubview(self.effectView)
            self.userInfoView.sendSubviewToBack(self.effectView)
            self.updateView.layer.cornerRadius = self.updateView.frame.height/2
            self.previewView.layer.cornerRadius = self.previewView.frame.height/2
        }
        
    }
    func addTopFade(frame:CGRect) {
        gradientLayer.frame = frame//CGRect(x: 0, y: tableView.frame.origin.y, width: tableView.bounds.width, height: 40.0)
        gradientLayer.masksToBounds = true
        
        gradientLayer.colors = [UIColor.AppPureBlackColour.withAlphaComponent(1.0).cgColor, UIColor.AppPureBlackColour.withAlphaComponent(0.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradiantView.layer.addSublayer(gradientLayer)
    }
    @IBAction func onclickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onClickJunpButton(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if #available(iOS 13.0, *) {
            alertController.overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
        let userId = userDefault.integer(forKey: CURRENTUSERID)
        let oneToOneMessageAction = UIAlertAction(title: "Flirt", style: .default, handler: { oneToOneAction  in
            self.moodTypeLabel.text = "Flirt"
            if self.isFromPetProfile {
                let object = ["user_signup_id" : userId,
                              "pet_profile_type" : 1,
                              "id_pet_onboarding" : self.petOnboardingID ?? 0]
                
                self.petOnBoardingViewModel.petOnBoardingChangeApiCall(parameter: object)
            }else {
                let object = ["user_signup_id" : userId,
                              "profile_type" : 1]
                self.onBoardingViewModel.onBoardingChangeApiCall(parameter: object)
            }
        })
        if self.moodTypeLabel.text == "Flirt"{
            oneToOneMessageAction.setValue(UIColor.AppWhiteColour, forKey: "titleTextColor")
        }else{
            oneToOneMessageAction.setValue(UIColor.AppAquaColour, forKey: "titleTextColor")
        }
        alertController.addAction(oneToOneMessageAction)
        
        let oneToGroupMessageAction = UIAlertAction(title: "Friend", style: .default, handler: { oneToGroupAction  in
            self.moodTypeLabel.text = "Friend"
            if self.isFromPetProfile {
                let object = ["user_signup_id" : userId,
                              "pet_profile_type" : 2,
                              "id_pet_onboarding" : self.petOnboardingID ?? 0]
                
                self.petOnBoardingViewModel.petOnBoardingChangeApiCall(parameter: object)
            }else {
                let object = ["user_signup_id" : userId,
                              "profile_type" : 2]
                self.onBoardingViewModel.onBoardingChangeApiCall(parameter: object)
            }
        })
        if self.moodTypeLabel.text == "Friend"{
            oneToGroupMessageAction.setValue(UIColor.AppWhiteColour, forKey: "titleTextColor")
        }else{
            oneToGroupMessageAction.setValue(UIColor.AppAquaColour, forKey: "titleTextColor")
        }
        alertController.addAction(oneToGroupMessageAction)
        
        let addToCommunityAction = UIAlertAction(title: "Formal", style: .default, handler: { [self] addToCommunity  in
            self.moodTypeLabel.text = "Formal"
            if self.isFromPetProfile {
                let object = ["user_signup_id" : userId,
                              "pet_profile_type" : 3,
                              "id_pet_onboarding" : self.petOnboardingID ?? 0]
                
                self.petOnBoardingViewModel.petOnBoardingChangeApiCall(parameter: object)
            }else {
                let object = ["user_signup_id" : userId,
                              "profile_type" : 3]
                self.onBoardingViewModel.onBoardingChangeApiCall(parameter: object)
            }
        })
        if self.moodTypeLabel.text == "Formal"{
            addToCommunityAction.setValue(UIColor.AppWhiteColour, forKey: "titleTextColor")
        }else{
            addToCommunityAction.setValue(UIColor.AppAquaColour, forKey: "titleTextColor")
        }
        if !self.isFromPetProfile {
            alertController.addAction(addToCommunityAction)
        }
        let addForeverAction = UIAlertAction(title: "Forever", style: .default, handler: { addToCommunity  in
            self.moodTypeLabel.text = "Forever"
            if self.isFromPetProfile {
                let object = ["user_signup_id" : userId,
                              "pet_profile_type" : 4,
                              "id_pet_onboarding" : self.petOnboardingID ?? 0]
                
                self.petOnBoardingViewModel.petOnBoardingChangeApiCall(parameter: object)
            }else {
                let object = ["user_signup_id" : userId,
                              "profile_type" : 4]
                self.onBoardingViewModel.onBoardingChangeApiCall(parameter: object)
            }
        })
        if self.moodTypeLabel.text == "Forever"{
            addForeverAction.setValue(UIColor.AppWhiteColour, forKey: "titleTextColor")
        }else{
            addForeverAction.setValue(UIColor.AppAquaColour, forKey: "titleTextColor")
        }
        if !self.isFromPetProfile {
            alertController.addAction(addForeverAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.AppWhiteColour, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onClickModechange(_ sender: Any) {
        let getMode = UserDefaults.standard.bool(forKey: DarkMode)
        if getMode {
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .light
                UserDefaults.standard.set(false, forKey: DarkMode)
                UserDefaults.standard.synchronize()
            } else {
                // Fallback on earlier versions
            }
            
        }else {
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .dark
                UserDefaults.standard.set(true, forKey: DarkMode)
                UserDefaults.standard.synchronize()
            } else {
                // Fallback on earlier versions
            }
            
        }
        
    }
    
    @IBAction func onClickPreviewButton(_ sender: Any) {
        if isFromPetProfile {
            guard let objVC = loadViewController(Storyboard: Storyboards.Profile, ViewController: ViewControllers.PreviewProfileVC) as? PreviewProfileVC else { return }
            objVC.isFromPetProfile = true
            objVC.petOnboardingID = petOnboardingID
            objVC.isFromPreview = true
            self.navigationController?.pushViewController(objVC, animated: true)
            return
        }
        guard let objVC = loadViewController(Storyboard: Storyboards.Profile, ViewController: ViewControllers.PreviewProfileVC) as? PreviewProfileVC else { return }
        objVC.isFromPreview = true
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func onClickChangeSubscriptionButton(_ sender: Any) {
        guard let objVC = loadViewController(Storyboard: Storyboards.Subscription, ViewController: ViewControllers.MainSubscriptionVC) as? MainSubscriptionVC else { return }
        objVC.isFromProfile = true
        objVC.delegate = self
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
}

extension ProfileVC: PagingMenuViewControllerDataSource {
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "identifier", for: index)  as! TitleLabelMenuViewCell
        cell.backgroundColor = .AppBlackColour
        cell.titleLabel.text = isFromPetProfile ? petDataSource[index].menuTitle : dataSource[index].menuTitle
        cell.titleLabel.textAlignment = .center
        cell.titleLabel.font = UIFont.init(name: fontName.PoppinsMedium, size: 16)
        cell.focusColor = focusCellTextColor
        cell.spacing = 0
        cell.normalColor = focusCellTextColor
        return cell
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return (topView.frame.width)/2
    }
    
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return isFromPetProfile ? petDataSource.count : dataSource.count
    }
}

extension ProfileVC: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return isFromPetProfile ? petDataSource.count : dataSource.count
    }
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return isFromPetProfile ? petDataSource[index].vc : dataSource[index].vc
    }
}

extension ProfileVC{
    func setSeqment(){
        // Segment
        menuViewController.register(type: TitleLabelMenuViewCell.self, forCellWithReuseIdentifier: "identifier")
        menuViewController.cellSpacing = betweenMenuCellSpacing // between cell specing
        menuViewController.registerFocusView(nib: focusView)
        menuViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // mainLineView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.5)
        menuViewController.focusView.selectedIndex = 1
        let lineView = (menuViewController.focusView.subviews[0] as! PagingMenuFocusView).subviews[0]
        
        //view height constraint.........
        let heightConstraint = lineView.heightAnchor.constraint(equalToConstant: focusLineViewHeightConstraint)
        lineView.addConstraint(heightConstraint)
        contentViewController.dataSource = self
        contentViewController.delegate = self
        
        DispatchQueue.main.async {
            if self.isForOpenSetting{
                self.menuViewController(viewController: self.menuViewController, didSelect: 1, previousPage: 0)
            }
            self.menuViewController.reloadData()
            self.contentViewController.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController.dataSource = self
            menuViewController.delegate = self
        }else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController.dataSource = self
            contentViewController.delegate = self
        }
    }
}

extension ProfileVC: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController?.scroll(to: page, animated: true)
    }
}

extension ProfileVC: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        //        if  indexValue != index{
        //            menuViewController?.scroll(index: index, percent: 0, animated: false)
        //            return
        //        }
        //        SpeedLog.print("percent%",percent)
        menuViewController?.scroll(index: index, percent: percent, animated: false)
    }
    
    func contentViewController(viewController: PagingContentViewController, willBeginPagingAt index: Int, animated: Bool){
        if isForOpenSetting{
            indexValue = 1
            menuViewController.scroll(index: 1)
        }
    }
    
    func contentViewController(viewController: PagingContentViewController, willFinishPagingAt index: Int, animated: Bool){
        indexValue = index
        //        if index == 0{
        //            self.heightOfPageContainer.constant = editViewHeight
        //        }else{
        //            self.heightOfPageContainer.constant = settingViewHeight
        //        }
        
        SpeedLog.print("NextPage ---> \(isFromPetProfile ? petDataSource[index].menuTitle : dataSource[index].menuTitle)")
    }
    func contentViewController(viewController: PagingContentViewController, didFinishPagingAt index: Int, animated: Bool){
        
    }
}

extension ProfileVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= topContentView.frame.height {
            gradiantView.backgroundColor = UIColor.AppBlackColour.withAlphaComponent(1)
        }else if scrollView.contentOffset.y <= 0 {
            gradiantView.backgroundColor = UIColor.AppBlackColour.withAlphaComponent(0)
        }else {
            gradiantView.backgroundColor = UIColor.AppBlackColour.withAlphaComponent(scrollView.contentOffset.y/topContentView.frame.height)
        }
    }
}

extension ProfileVC : UserProfileDelegate{
    func GetProfileDataSuccessfully() {
        userModel = viewModel.profileModelObject
        setUpProfileData()
    }
    func GetPetProfileDataSuccessfully() {
        petProfileModel = viewModel.petProfileModelObject
        setUpProfileData()
    }
    
    func GetAllProfilesDataSuccessfully() {
        
    }
    
    func GetAllProfilesDataError() {
        
    }
    func GetAllPetProfileSuccessfully() {
        
    }
}
enum ProfileTypeEnum: Int,CaseIterable {
    case  Flirt,Friend,Formal,Forever
    
    func type() -> String {
        switch self {
        case .Flirt:
            return "Flirt"
        case .Friend:
            return "Friend"
        case .Formal:
            return "Formal"
        case .Forever:
            return "Forever"
        }
    }
}

enum SubscriptionTypeEnum: Int,CaseIterable {
    case Marvel, Magic, Moon, Milkyway
    
    func type() -> String {
        switch self {
        case .Marvel:
            return "MARVEL"
        case .Magic:
            return "MAGIC"
        case .Moon:
            return "MOON"
        case .Milkyway:
            return "MILKYWAY"
        }
    }
}

extension ProfileVC :ChangeHeightOfContainerViewDelegate {
    func changeHeight(heightSize: CGFloat, isEditProfile: Bool) {
        if isEditProfile{
            editViewHeight =  heightSize
            self.heightOfPageContainer.constant = editViewHeight
        }else{
            settingViewHeight = heightSize
            self.heightOfPageContainer.constant = settingViewHeight
        }
    }
    
    func transferPostArray(postArray: [PostResultModel]) {
        postArrayObject = postArray
        postURL = postArrayObject?[0].uploadedPhotoUrl ?? ""
        sideDelegate?.updateProfilePicture(position: position, imageURL: postURL ?? "")
        SetUpImageData()
    }
}

protocol ChangeHeightOfContainerViewDelegate {
    func changeHeight(heightSize : CGFloat, isEditProfile : Bool)
    func transferPostArray(postArray : [PostResultModel])
}

extension ProfileVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(navigationController?.interactivePopGestureRecognizer) {
            navigationController?.popViewController(animated: true)
        }
        return false
    }
}

extension ProfileVC : SubscriptionConfirmationUpdateDelegate{
    func UpdateSubscription() {
        self.subscriptionTitleLabel.text = "\(userDefault.string(forKey: SubscritpionTypeName) ?? "") · \(userDefault.string(forKey: SubscriptionDurationName) ?? "")"
        let dateFormater = DateFormatter()
        let expiredDateString = userDefault.string(forKey: SubscriptionExpireDate) ?? ""
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateOfBirth = dateFormater.date(from: expiredDateString)
        dateFormater.dateFormat = "d MMM yyyy"
        subscriptionTypeLable.text = expiredDateString == "" ? "My subscriptions" : "Next Renewal on \(dateFormater.string(from: dateOfBirth ?? Date()))"
    }
}
