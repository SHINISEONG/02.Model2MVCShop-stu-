<%@page import="com.model2.mvc.service.product.ProductService"%>
<%@ page contentType="text/html; charset=euc-kr" %>

<%@ page import="java.util.*"  %>
<%@ page import="com.model2.mvc.service.purchase.vo.*" %>
<%@ page import="com.model2.mvc.service.product.vo.*" %>
<%@ page import="com.model2.mvc.service.user.vo.*" %>
<%@ page import="com.model2.mvc.common.*" %>
<%@ page import="com.model2.mvc.service.purchase.impl.*" %>
<%@ page import="com.model2.mvc.service.purchase.*" %>


<%
	HashMap<String,Object> map=(HashMap<String,Object>)request.getAttribute("map");
	SearchVO searchVO=(SearchVO)request.getAttribute("searchVO");
	
	int total=0;
	ArrayList<ProductVO> list=null;
	if(map != null){
		total=((Integer)map.get("count")).intValue();
		list=(ArrayList<ProductVO>)map.get("list");
	}
	
	int currentPage=searchVO.getPage();
	
	int totalPage=0;
	if(total > 0) {
		totalPage= total / searchVO.getPageUnit() ;
		if(total%searchVO.getPageUnit() >0)
			totalPage += 1;
	}
	
	if(searchVO.getSearchCondition()==null){
		searchVO.setSearchCondition("");
	}
	String menu="";
	menu = request.getParameter("menu");
	
	PurchaseService purchaseService = new PurchaseServiceImpl();
	
	HashMap<String, Object> saleMap = purchaseService.getSaleList(searchVO);
	
	UserVO userVO = (UserVO)session.getAttribute("user");
	
	
%>



<html>
<head>
<title>��ǰ �����ȸ</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script type="text/javascript">
<!--
function fncGetProductList(){
	document.detailForm.submit();
}
-->
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm" action="/listProduct.do?menu=<%=menu%>" method="post">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
					<%if (menu.equals("manage")) {%>
						��ǰ ����
					<%} else if (menu.equals("search")){%>
						��ǰ �����ȸ
					<%} %>
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		
		<td align="right">
			<select name="searchCondition" class="ct_input_g" style="width:80px">
					
					<option value="0" <%= searchVO.getSearchCondition().equals("")||searchVO.getSearchCondition().equals("0")?"selected":"" %>>��ǰ��ȣ</option>
					<option value="1" <%= searchVO.getSearchCondition().equals("1")?"selected":"" %>>��ǰ��</option>
					<option value="2" <%= searchVO.getSearchCondition().equals("2")?"selected":"" %>>��ǰ����</option>
			</select>
			<input type="text" name="searchKeyword" value="<%= searchVO.getSearchCondition()== "" ? "" : searchVO.getSearchKeyword() %>" class="ct_input_g" style="width:200px; height:19px" />
		</td>
	
		
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<a href="javascript:fncGetProductList();">�˻�</a>
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >��ü  <%= total%> �Ǽ�, ���� <%=currentPage %> ������</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">��ǰ��</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">����</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">�����</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">�������</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	<%
		int no=list.size();
		for(int i=0; i<list.size(); i++) {
			ProductVO vo = (ProductVO)list.get(i);
			String prodNo = Integer.toString(vo.getProdNo());
			System.out.println("prod No st: " + prodNo);
			String tranNo = "";
			int tranCode = 0;
			PurchaseVO purchaseVO = new PurchaseVO();
			if(saleMap.containsKey(prodNo)) {
				tranNo = (String)saleMap.get(prodNo);
				purchaseVO = purchaseService.findPerchase(Integer.parseInt(tranNo.trim()));
				System.out.println("tran code : " + purchaseVO.getTranCode());
				tranCode = Integer.parseInt(purchaseVO.getTranCode().trim());
			}
				System.out.println("tran No : "+tranNo);
			
	%>
	<tr class="ct_list_pop">
		<td align="center"><%=no--%></td>
		<td></td>
				
				<td align="left">
				<%if(!(saleMap.containsKey(prodNo))) {%>
				<a href="/getProduct.do?prodNo=<%=vo.getProdNo()%>&menu=<%=menu%>"><%=vo.getProdName()%></a></td>
				<%} else {%>
					<%if(userVO.getUserId().equals("admin")) {%>
						<a href="/getProduct.do?prodNo=<%=vo.getProdNo()%>&menu=<%=menu%>"><%=vo.getProdName()%></a></td>
					<%} else {%>
					
					<%=vo.getProdName()%></td>
					
					<%} %>
				<%} %>
		
		<td></td>
		<td align="left"><%=vo.getPrice()%></td>
		<td></td>
		<td align="left"><%=vo.getRegDate()%></td>
		<td></td>
		<td align="left">
		<%if(menu.equals("search")) {%>
			<%if(!(userVO.getUserId().equals("admin"))) {%>
				<%if(!(saleMap.containsKey(prodNo))) {%>
					 	�Ǹ���
					<%} else {%>
						��� ����
					<%} %>
			<%} else {%>
				<%if(tranCode==0) {%>
					�Ǹ���
				<%} %>
				
				<%if(tranCode==1) {%>
					���ſϷ�
				<%} %>
				
				<%if(tranCode==2) {%>
					�����
				<%} %>
				
				<%if(tranCode==3) {%>
					��ۿϷ�
				<%} %>
				
			<%} %>
		<%} else if(menu.equals("manage")) {%>
				
				<%if(tranCode==0) {%>
					�Ǹ���
				<%} %>
				
				<%if(tranCode==1) {%>
					���ſϷ�
					&nbsp;
					<a href="/updateTranCodeByProd.do?prodNo=<%=vo.getProdNo() %>&tranCode=2&searchCondition=<%=searchVO.getSearchCondition()%>&searchKeyword=<%=searchVO.getSearchKeyword()%>&page=<%=searchVO.getPage()%>">����ϱ�</a>
				<%} %>
				
				<%if(tranCode==2) {%>
					�����
				<%} %>
				
				<%if(tranCode==3) {%>
					��ۿϷ�
				<%} %>
				
		<%} %>
		</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>	
<% } //end of for %>
		
	
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
		<%
	  		for(int i=1;i<=totalPage;i++){
		%>
			<a href="/listProduct.do?page=<%=i%>&menu=<%=menu%>&searchKeyword=<%=searchVO.getSearchKeyword()%>&searchCondition=<%=searchVO.getSearchCondition()%>"><%=i%></a>
		<% } %>
		
    	</td>
	</tr>
</table>
<!--  ������ Navigator �� -->

</form>

</div>
</body>
</html>