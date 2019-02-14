
local _LoginView = class(ViewBase)

function _LoginView:OnCreate()
    print("_LoginView oncreate  ~~~~~~~")

    self.centerBlock = self:InitCenterBlock(self.transform, "center")

end

function  _LoginView:InitCenterBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.accountInput = transform:Find("part1/input"):GetComponent("InputField")
    block.passwordInput = transform:Find("part2/input"):GetComponent("InputField")

    block.loginBtn = transform:Find("btns/loginBtn").gameObject
    block.registeBtn = transform:Find("btns/registeBtn").gameObject

    block.loginBtn:SetOnClick(function ()
        self:OnLoginBtnClick()
    end)
    block.registeBtn:SetOnClick(function ()
        self:OnRegisteBtnClick()
    end)
    
    return block
end

function _LoginView:OnLoginBtnClick()
    print("OnLoginBtnClick ~~~~~")
    local accout = self.centerBlock.accountInput.text
    local password = self.centerBlock.passwordInput.text
    self.iCtrl:Login(accout, password)
end

function _LoginView:OnRegisteBtnClick()
    print("OnRegisteBtnClick ~~~~~")
    local accout = self.centerBlock.accountInput.text
    local password = self.centerBlock.passwordInput.text
    self.iCtrl:Registe(accout, password)
end

function _LoginView:OnDestroy()
    
end

return _LoginView