class VideoCallingRenderView: UIView {
    
    private var isViewReady: Bool = false
    
    var userModel = CallingUserModel() {
        didSet {
            configModel(model: userModel)
        }
    }
    
    lazy var cellImgView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    lazy var cellUserLabel: UILabel = {
        let user = UILabel()
        user.textColor = .white
        user.backgroundColor = UIColor.clear
        user.textAlignment = .center
        user.font = UIFont.systemFont(ofSize: 11)
        user.numberOfLines = 2
        return user
    }()
    
    let volumeProgress: UIProgressView = {
        let progress = UIProgressView.init()
        progress.backgroundColor = .clear
        return progress
    }()
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard !isViewReady else {
            return
        }
        isViewReady = true
        addSubview(cellImgView)
        cellImgView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-20)
        }
        addSubview(cellUserLabel)
        cellUserLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(22)
            make.top.equalTo(cellImgView.snp.bottom).offset(2)
        }
        addSubview(volumeProgress)
        volumeProgress.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
    }
    
    func configModel(model: CallingUserModel) {
        backgroundColor = .darkGray
        let noModel = model.userId.count == 0
        if !noModel {
            cellUserLabel.text = model.name
            cellImgView.setImage(model.avatarUrl)
            cellImgView.isHidden = model.isVideoAvaliable
            cellUserLabel.isHidden = model.isVideoAvaliable
            volumeProgress.progress = model.volume
        }
        volumeProgress.isHidden = noModel
    }
}
