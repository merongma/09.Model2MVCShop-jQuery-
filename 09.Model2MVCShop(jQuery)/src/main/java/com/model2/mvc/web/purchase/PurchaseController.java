package com.model2.mvc.web.purchase;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.purchase.PurchaseService;
import com.model2.mvc.service.purchase.impl.PurchaseServiceImpl;
import com.model2.mvc.service.user.UserService;
import com.model2.mvc.service.user.impl.UserServiceImpl;

//==> ȸ������ Controller
@Controller
@RequestMapping("/purchase/*")
public class PurchaseController {

	/// Field
	@Autowired
	@Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;

	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	// setter Method ���� ����

	public PurchaseController() {
		System.out.println(this.getClass());
	}

	// ==> classpath:config/common.properties , classpath:config/commonservice.xml
	// ���� �Ұ�
	// ==> �Ʒ��� �ΰ��� �ּ��� Ǯ�� �ǹ̸� Ȯ�� �Ұ�
	@Value("#{commonProperties['pageUnit']}")
	// @Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;

	@Value("#{commonProperties['pageSize']}")
	// @Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;

	@RequestMapping(value = "addPurchaseView", method = RequestMethod.GET)
	public String addPurchaseView(@RequestParam("prodNo") int prodNo, Model model) throws Exception {

		System.out.println("/purchase/addPurchaseView : GET");

		Product product = productService.getProduct(prodNo);

		model.addAttribute("product", product);

		System.out.println(product);

		return "forward:/purchase/addPurchaseView.jsp";
	}

	@RequestMapping(value = "addPurchase", method = RequestMethod.POST)
	public String addPurchase(@RequestParam("prodNo") int prodNo, @RequestParam("buyerId") String buyerId,
			@ModelAttribute("purchase") Purchase purchase, Model model) throws Exception {

		System.out.println("/purchase/addPurchase : POST");

		Product product = productService.getProduct(prodNo);
		User user = userService.getUser(buyerId);

		purchase.setBuyer(user);
		purchase.setPurchaseProd(product);

		purchaseService.addPurchase(purchase);

		purchase.setPaymentOption(purchase.getPaymentOption().trim());

		model.addAttribute(purchase);

		return "forward:/purchase/addPurchaseViewResult.jsp";
	}

	@RequestMapping(value = "getPurchase")
	public String getPurchase(@RequestParam("tranNo") int tranNo, Model model) throws Exception {

		System.out.println("/purchase/getPurchase : GET / POST");

		Purchase purchase = purchaseService.getPurchase(tranNo);

		model.addAttribute("purchase", purchase);

		purchase.setPaymentOption(purchase.getPaymentOption().trim());

		return "forward:/purchase/getPurchaseView.jsp";

	}

	@RequestMapping(value = "listPurchase")
	public String listPurchase(@ModelAttribute("search") Search search, Model model, HttpServletRequest request)
			throws Exception {

		System.out.println("/user/listPurchase : GET / POST");

		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);

		User user = (User) request.getSession().getAttribute("user");
		String buyerId = user.getUserId();
		System.out.println("session buyerid : " + buyerId);

		// Business logic ����
		Map<String, Object> map = purchaseService.getPurchaseList(search, buyerId);

		Page resultPage = new Page(search.getCurrentPage(), ((Integer) map.get("totalCount")).intValue(), pageUnit,
				pageSize);
		System.out.println(resultPage);

		// Model �� View ����
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);

		return "forward:/purchase/listPurchase.jsp";
	}

	@RequestMapping(value = "updatePurchase", method = RequestMethod.POST)
	public String updatePurchase(@ModelAttribute("Purchase") Purchase purchase, @RequestParam("tranNo") int tranNo,
			Model model) throws Exception {

		System.out.println("/purchase/updatePurchase : POST");

		purchase.setTranNo(tranNo);
		purchaseService.updatePurchase(purchase);

		model.addAttribute("purchase", purchase);

		return "forward:/purchase/getPurchase";
	}

	@RequestMapping(value = "updatePurchaseView", method = RequestMethod.GET)
	public String updatePurchaseView(@ModelAttribute("Purchase") Purchase purchase, @RequestParam("tranNo") int tranNo,
			Model model) throws Exception {

		System.out.println("/purchase/updatePurchaseView : GET");

		purchase = purchaseService.getPurchase(tranNo);

		model.addAttribute("purchase", purchase);

		return "forward:/purchase/updatePurchaseView.jsp";

	}

	@RequestMapping(value = "updateTranCodeByProd", method = RequestMethod.GET)
	public String updateTranCodeByProd(@ModelAttribute("Purchase") Purchase purchase,
			@ModelAttribute("Product") Product product, @RequestParam("tranCode") String tranCode,
			@RequestParam("prodNo") int prodNo) throws Exception {

		System.out.println("/purchase/updateTranCodeByProd : GET");

		product.setProdNo(prodNo);
		purchase.setPurchaseProd(product);

		purchase.setTranCode(tranCode);
		System.out.println("1" + purchase);
		purchaseService.updateTranCode(purchase);
		System.out.println("2" + purchase);

		return "forward:/product/listProduct?prodNo=" + prodNo;
	}

	@RequestMapping(value = "updateTranCode", method = RequestMethod.GET)
	public String updateTranCode(@RequestParam("tranCode") String tranCode, @RequestParam("tranNo") int tranNo,
			@ModelAttribute("Product") Product product) throws Exception {

		System.out.println("/purchase/updateTranCode : GET");

		Purchase purchase = purchaseService.getPurchase(tranNo);
	
		product.setProdNo(purchase.getPurchaseProd().getProdNo());

		purchase.setTranCode(tranCode);
		purchase.setPurchaseProd(product);

		purchaseService.updateTranCode(purchase);

		return "forward:/purchase/listPurchase?tranNo=" + tranNo;
	}

}