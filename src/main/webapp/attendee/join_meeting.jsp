<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>参会登记 - 会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/joinMeeting.css">
</head>
<body style="background:#f5f6fa;min-height:100vh;">
<div class="join-meeting-wrapper">
    <div class="content-card mb-4">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-info-circle text-primary me-2"></i>会议信息
            </h5>
        </div>
        <div class="card-body">
            <div class="row g-3" id="conferenceInfo">
                <div class="col-md-6">
                    <label class="info-label">会议名称</label>
                    <p class="info-value" id="confTitle">加载中...</p>
                </div>
                <div class="col-md-3">
                    <label class="info-label">开始时间</label>
                    <p class="info-value" id="confStartDate">--</p>
                </div>
                <div class="col-md-3">
                    <label class="info-label">结束时间</label>
                    <p class="info-value" id="confEndDate">--</p>
                </div>
                <div class="col-md-6">
                    <label class="info-label">会议地点</label>
                    <p class="info-value" id="confVenue">--</p>
                </div>
                <div class="col-md-6">
                    <label class="info-label">住宿地址</label>
                    <p class="info-value" id="confDorms">--</p>
                </div>
                <div class="col-md-6">
                    <label class="info-label">报名费用</label>
                    <p class="info-value" id="confAmount">--</p>
                </div>
            </div>
        </div>
    </div>

    <div class="content-card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-clipboard-list text-primary me-2"></i>参会登记
            </h5>
        </div>
        <div class="card-body">
            <form id="joinForm" novalidate>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="arrivalTime" class="form-label required">预计到达时间</label>
                        <input type="datetime-local" class="form-control form-input" id="arrivalTime" name="arrivalTime" onchange="saveFormData()"required >
                    </div>
                    <div class="col-md-6">
                        <label for="departureTime" class="form-label required">预计离开时间</label>
                        <input type="datetime-local" class="form-control form-input" id="departureTime" name="departureTime" onchange="saveFormData()" required>
                    </div>
                    <div class="col-md-6">
                        <label for="accommodationType" class="form-label">住宿要求</label>
                        <select class="form-select form-input" id="accommodationType" name="accommodationType" onchange="saveFormData()">
                            <option value="">请选择...</option>
                            <option value="单人间">单人间</option>
                            <option value="双人间">双人间</option>
                            <option value="无需安排">无需安排</option>
                            <option value="主办方统一安排">主办方统一安排</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="requirements" class="form-label">其他要求</label>
                        <input type="text" class="form-control form-input" id="requirements" name="requirements" maxlength="50" placeholder="如有特殊饮食、接站等需求请备注" onchange="saveFormData()">
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 已报名时显示：只读信息卡片 -->
    <div class="content-card" id="registeredInfoCard" style="display:none;">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-check-circle text-success me-2"></i>报名信息
                <span class="badge bg-success ms-2">已报名</span>
            </h5>
        </div>
        <div class="card-body">
            <div class="row g-3" id="registeredInfo">
                <div class="col-md-6">
                    <label class="info-label text-muted">预计到达</label>
                    <p class="info-value fw-bold" id="regArrival">--</p>
                </div>
                <div class="col-md-6">
                    <label class="info-label text-muted">预计离开</label>
                    <p class="info-value fw-bold" id="regDeparture">--</p>
                </div>
                <div class="col-md-6">
                    <label class="info-label text-muted">住宿要求</label>
                    <p class="info-value" id="regAccommodation">--</p>
                </div>
                <div class="col-md-6">
                    <label class="info-label text-muted">其他备注</label>
                    <p class="info-value" id="regRequirements">--</p>
                </div>
            </div>
            <hr>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="border rounded p-3 text-center">
                        <div class="text-muted small mb-1">签到状态</div>
                        <div id="regCheckin" class="fw-bold">--</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="border rounded p-3 text-center">
                        <div class="text-muted small mb-1">入住房间</div>
                        <div id="regRoom" class="fw-bold">--</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="border rounded p-3 text-center">
                        <div class="text-muted small mb-1">缴费状态</div>
                        <div id="regPayment" class="fw-bold">--</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="action-buttons">
        <button type="button" id="btnJoin" class="btn btn-join-action" onclick="submitJoin()">
            <i class="fas fa-sign-in-alt me-1"></i>确认参加
        </button>
        <button type="button" id="btnPay" class="btn btn-pay-action" onclick="goToPayment()" disabled>
            <i class="fas fa-credit-card me-1"></i>在线缴费
        </button>
        <button type="button" id="btnBack" class="btn btn-outline-secondary" style="display:none;"
                onclick="window.location.href=contextPath+'/index2.jsp'">
            <i class="fas fa-arrow-left me-1"></i>返回
        </button>
    </div>
</div>

<script>
var contextPath = '<%= request.getContextPath() %>';
var conferenceId = '<%= request.getParameter("id") %>';
var inviteCodes = '<%= request.getParameter("invite_codes") %>';
var attendanceId = null;
</script>
<script src="${pageContext.request.contextPath}/js/joinMeeting.js"></script>
</body>
</html>
