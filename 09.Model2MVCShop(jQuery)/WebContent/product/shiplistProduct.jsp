<%@ page contentType="text/html; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title></title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">

//fncGetProductList(currentPage) 입니당~~~
function fncGetUserList(currentPage) {

	$("#currentPage").val(currentPage)
   	
	$("form").attr("method" , "POST").attr("action" , "/product/listProduct?menu=${param.menu}").submit();
}

 $(function() {
	 
	 $( "td.ct_btn01:contains('검색')" ).on("click" , function() {
		fncGetUserList(1);
	});
	
	
	$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
			
			self.location ="/product/getProduct?prodNo="+$(this).children("input").val()+"&menu=${param.menu}";
	});
	
	
	$( "h8:contains('배송하기')" ).on("click" , function() {
		//alert($("#prodNo").val());
		self.location ="/purchase/updateTranCodeByProd?menu=manage&prodNo="+$("#prodNo").val()+"&tranCode=2";
	});

	$( ".ct_list_pop td:nth-child(3)" ).css("color" , "green");
	$("h7").css("color" , "green");
	$("h8").css("color" , "blue");
	
	$(".ct_list_pop td:nth-child(9):contains('품절')").css("color","red");
	
	$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");

});	
	

</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm" >

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
					<!--manage인 경우 상품관리 search인경우 상품목록조회 -->
					<c:if test="${param.menu=='manage'}" >
						상품관리
					</c:if>
					<c:if test="${param.menu=='search'}" >
						상품 목록조회
					</c:if>
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
				<option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
				<option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
				<option value="2"  ${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>상품가격</option>
			</select>
			<input type="text" name="searchKeyword" 
						value="${! empty search.searchKeyword ? search.searchKeyword : ""}"  
								class="ct_input_g" style="width:200px; height:19px" >
			</td>

				<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						검색
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
		<td colspan="11" >
		전체  ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage } 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명<br>
			<h7 >(상품명 click:상세정보)</h7>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">상품상세정보</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>
		<td class="ct_line02"></td>
		<c:if test = "${param.menu =='manage'}">
		<td class="ct_list_b">재고</td>
		<td class="ct_line02"></td></c:if>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>

	
	<c:set var = "i" value = "0"/>
	<c:forEach var ="product" items ="${list }">
		<c:set var="i"  value = "${i+1 }"/>
		<tr class="ct_list_pop">
			<td align="center">${i }</td>
			<td></td>
			<td align="left"><input type="hidden" name="prodNo"  value="${product.prodNo }" />
			${product.prodName }</td>
			<td></td>
			<td align="left">${product.price }원</td>
			<td></td>
			<td align="left">${product.prodDetail }</td>		
			<td></td>
			<td align="left">
				<c:if test="${product.stock!=0 }">판매중</c:if>
				<c:if test="${product.stock==0 && (empty user ||  empty product.proTranCode)}">품절</c:if>
				
				<c:if test="${! empty product.proTranCode && product.proTranCode=='1  '}">
					<c:if test="${user.role=='admin' && param.menu=='manage'}">구매완료
					<h8>배송하기</h8>
					<input type="hidden" name="prodNo" id="prodNo"  value="${product.prodNo }" />
					</c:if>
					<c:if test="${param.menu=='search' && ! empty user.role && product.stock==0 }">품절</c:if>
				</c:if>
				
				<c:if test="${! empty product.proTranCode && product.proTranCode=='2  '}">
					<c:if test="${user.role=='admin' && param.menu=='manage'}">배송중</c:if>
					<c:if test="${param.menu=='search' && ! empty user.role &&product.stock==0  }">품절</c:if>
				</c:if>
				
				<c:if test="${! empty product.proTranCode && product.proTranCode=='3  '}">
					<c:if test="${user.role=='admin' && param.menu=='manage'}">배송완료</c:if>
					<c:if test="${param.menu=='search' && ! empty user.role &&product.stock==0 }">품절</c:if>
				</c:if>
			</td>	
			<c:if test = "${param.menu =='manage'}">	
			<td align="left">${product.stock } 개</td>
			<td></td></c:if>
		</tr>
		<tr>
			<td colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>
	</c:forEach>
</table>

<!--  페이지 Navigator 시작 -->
<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top:10px;">
	<tr>
		<td align="center">
		   <input type="hidden" id="currentPage" name="currentPage" value=""/>
	
			<jsp:include page="../common/pageNavigator.jsp"/>	
			
    	</td>
	</tr>
</table>
<!--  페이지 Navigator 끝 -->

</form>
</div>
</body>
</html>
