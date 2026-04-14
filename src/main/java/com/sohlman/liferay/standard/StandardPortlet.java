package com.sohlman.liferay.standard;

import java.io.IOException;

import javax.portlet.GenericPortlet;
import javax.portlet.HeaderRequest;
import javax.portlet.HeaderResponse;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

public class StandardPortlet extends GenericPortlet {

	@Override
	public void renderHeaders(HeaderRequest request, HeaderResponse response)
			throws PortletException, IOException {
		System.out.println("StandardPortlet.renderHeaders() called — Portlet 3.0 header phase is supported");
		response.getWriter().write("<meta content=\"portlet=standard-portlet\" />");
	}

	@Override
	public void render(RenderRequest renderRequest, RenderResponse renderResponse)
			throws PortletException, IOException {
		System.out.println("StandardPortlet.render() called");
		renderResponse.getWriter().write("<h1>Hello World!</h1>");
	}
}
