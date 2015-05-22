<%            /**************************************************************************
            Copyright (c) 2011:
            Istituto Nazionale di Fisica Nucleare (INFN), Italy
            Consorzio COMETA (COMETA), Italy

            See http://www.infn.it and and http://www.consorzio-cometa.it for details on the
            copyright holders.

            Licensed under the Apache License, Version 2.0 (the "License");
            you may not use this file except in compliance with the License.
            You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

            Unless required by applicable law or agreed to in writing, software
            distributed under the License is distributed on an "AS IS" BASIS,
            WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
            See the License for the specific language governing permissions and
            limitations under the License.
             ****************************************************************************/
            /**
             *
             *
             * @author m.fargetta - s.monforte - r.ricceri
             */

%>
<%@page contentType="text/xml" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.liferay.portal.service.persistence.PortletUtil"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<% pageContext.setAttribute("name", request.getAttribute("name"));%>


    <c:choose>
        <c:when test="${name=='africa'}">
                <sql:query var="areas" dataSource="jdbc/ChainMap">
                SELECT *, FIND_IN_SET(_country.region,'SSF,MEA') > 0 as balloon FROM all_vista LEFT JOIN _country ON (_country.iso2Code = all_vista.ISOcode) LEFT JOIN all_opendoar on (all_vista.ISOcode = all_opendoar.country_code)  ORDER BY balloon DESC
                </sql:query>
                <map map_file="maps/world3.swf" zoom="250%" zoom_x="-84.94%" zoom_y="-118.95%" tl_long="-168.49" tl_lat="83.63" br_long="190.3" br_lat="-55.58" >
        </c:when>
        <c:when test="${name=='asia'}">
                <sql:query var="areas" dataSource="jdbc/ChainMap">
                SELECT *, FIND_IN_SET(_country.region,'SAS,ECS,EAS') > 0 as balloon FROM all_vista LEFT JOIN _country ON (_country.iso2Code = all_vista.ISOcode)  LEFT JOIN all_opendoar on (all_vista.ISOcode = all_opendoar.country_code) ORDER BY balloon DESC
                </sql:query>
                <map map_file="maps/world3.swf" zoom="130%" zoom_x="-45.46%" zoom_y="-10.18%" tl_long="-168.49" tl_lat="83.63" br_long="190.3" br_lat="-55.58" >
        </c:when>
        <c:when test="${name=='latinamerica'}">
                <sql:query var="areas" dataSource="jdbc/ChainMap">
                SELECT *, FIND_IN_SET(_country.region,'LCN') > 0 as balloon FROM all_vista LEFT JOIN _country ON (_country.iso2Code = all_vista.ISOcode)  LEFT JOIN all_opendoar on (all_vista.ISOcode = all_opendoar.country_code) ORDER BY balloon DESC
                </sql:query>
                <map map_file="maps/world3.swf" zoom="219%" zoom_x="2.44%" zoom_y="-120.36%" tl_long="-168.49" tl_lat="83.63" br_long="190.3" br_lat="-55.58" >
        </c:when>
        <c:when test="${name=='nordamerica'}">
                <sql:query var="areas" dataSource="jdbc/ChainMap">
                SELECT *, FIND_IN_SET(_country.region,'NAC') > 0 as balloon FROM all_vista LEFT JOIN _country ON (_country.iso2Code = all_vista.ISOcode)  LEFT JOIN all_opendoar on (all_vista.ISOcode = all_opendoar.country_code) ORDER BY balloon DESC
                </sql:query>
                <map map_file="maps/world3.swf" zoom="270%" zoom_x="10.51%" zoom_y="-50.75%" tl_long="-168.49" tl_lat="83.63" br_long="190.3" br_lat="-55.58" >
        </c:when>
        <c:when test="${name=='oceania'}">
                <sql:query var="areas" dataSource="jdbc/ChainMap">
                SELECT *, FIND_IN_SET(_country.region,'OCE') > 0 as balloon FROM all_vista LEFT JOIN _country ON (_country.iso2Code = all_vista.ISOcode)  LEFT JOIN all_opendoar on (all_vista.ISOcode = all_opendoar.country_code) ORDER BY balloon DESC
                </sql:query>
                <map map_file="maps/world3.swf" zoom="400%" zoom_x="-294.35%" zoom_y="-280.58%" tl_long="-168.49" tl_lat="83.63" br_long="190.3" br_lat="-55.58" >
        </c:when>
    </c:choose>
    <areas>
        
              <c:forEach var="country" items="${areas.rows}">
                    <c:if test="${((!empty country.ROC) or (!empty country.REG) or (!empty country.NREN)) and country.balloon == 1}">
                <area  color="#a5a6a7" mc_name="<c:out value="${country.iso2Code}"/>" title="<c:out value="${country.name}"/>">
                <description>
                    <c:set var="reg" value="${country.REG}"/>
                    <c:set var="reg">${fn:replace(reg,"<li>","")}</c:set>
                    <c:set var="reg">${fn:replace(reg,"</li>"," , ")}</c:set>
                    <c:set var="reg">${fn:replace(reg,"<ul>","")}</c:set>
                    <c:set var="reg">${fn:replace(reg,"</ul>","")}</c:set>

                    <jsp:useBean id="reg" type="java.lang.String"/>

                    <c:set var="nren" value="${country.NREN}"/>
                    <c:set var="nren">${fn:replace(nren,"<li>","")}</c:set>
                    <c:set var="nren">${fn:replace(nren,"</li>"," , ")}</c:set>
                    <c:set var="nren">${fn:replace(nren,"<ul>","")}</c:set>
                    <c:set var="nren">${fn:replace(nren,"</ul>","")}</c:set>

                    <jsp:useBean id="nren" type="java.lang.String"/>


                    <c:set var="roc" value="${country.ROC}"/>
                    <c:set var="roc">${fn:replace(roc,"<li>","")}</c:set>
                    <c:set var="roc">${fn:replace(roc,"</li>"," , ")}</c:set>
                    <c:set var="roc">${fn:replace(roc,"<ul>","")}</c:set>
                    <c:set var="roc">${fn:replace(roc,"</ul>","")}</c:set>

                    <jsp:useBean id="roc" type="java.lang.String"/>

                    <c:set var="apps" value="${country.APPLICATION}"/>
                    <c:set var="apps">${fn:replace(apps,"<li>","")}</c:set>
                    <c:set var="apps">${fn:replace(apps,"</li>",",")}</c:set>
                    <c:set var="apps">${fn:replace(apps,"<ul>","")}</c:set>
                    <c:set var="apps">${fn:replace(apps,"</ul>","")}</c:set>

                    <jsp:useBean id="apps" type="java.lang.String"/>

                    <c:set var="site" value="${country.SITE_CHAIN}"/>
                    <c:set var="site">${fn:replace(site,"<li>","")}</c:set>
                    <c:set var="site">${fn:replace(site,"</li>",", ")}</c:set>
                    <c:set var="site">${fn:replace(site,"<ul>","")}</c:set>
                    <c:set var="site">${fn:replace(site,"</ul>","")}</c:set>

                    <jsp:useBean id="site" type="java.lang.String"/>

                    <c:set var="siteigi" value="${country.SITE_IGI}"/>
                    <c:set var="siteigi">${fn:replace(siteigi,"<li>","")}</c:set>
                    <c:set var="siteigi">${fn:replace(siteigi,"</li>",", ")}</c:set>
                    <c:set var="siteigi">${fn:replace(siteigi,"<ul>","")}</c:set>
                    <c:set var="siteigi">${fn:replace(siteigi,"</ul>","")}</c:set>

                    <jsp:useBean id="siteigi" type="java.lang.String"/>

<%!
    private String rtrim(String s, char ch) {
        return s.lastIndexOf(ch) > 0 ? s.substring(0, s.lastIndexOf(ch)) : s;
    }
%>

                    <![CDATA[<textformat tabstops='[360]'><c:if test="${(!empty country.REG)}"><br/><img src='/ChainMap/script/ammap/icons/network_wired.png'/><br/><font color="#838383"><b>Regional Network:</b></font><font color="#0669CE"><c:out value="<%=rtrim(reg,',')%>" escapeXml="false"/> </font></c:if>
                    <c:if test="${(!empty country.NREN)}"><br/><br/><img src='/ChainMap/script/ammap/icons/wireless.png'/><br/><font color="#838383"><b>National Research Education Network: </b></font><font color="#0669CE"><c:out value="<%=rtrim(nren,',')%>" escapeXml="false"/>  </font></c:if>
                    <c:if test="${(!empty country.NGI)}"><br/><br/><img src='/ChainMap/script/ammap/icons/ngi.png'/><br/><font color="#838383"><b>National Grid Initiative: </b></font><font color="#0669CE"><a href="<c:out value="${country.NGI_URL}"/>" target="_blank"><c:out value="${country.NGI}" escapeXml="false"/> </a></font></c:if>
                    <c:if test="${(!empty country.CA)}"><br/><br/><img src='/ChainMap/script/ammap/icons/ca.png'/><br/><font color="#838383"><b>Certification Authority: </b></font><font color="#0669CE"><a href="<c:out value="${country.URL_CA}"/>" target="_blank"><c:out value="${country.CA}" escapeXml="false"/></a></font></c:if>
                    <c:choose><c:when test="${(!empty country.IdF)}"><br/><br/><img src='/ChainMap/script/ammap/icons/IdF.png'/><br/><font color="#838383"><b>Identity federation: </b></font><font color="#0669CE"><a href="<c:out value="${country.URL_IdF}"/>" target="_blank"><c:out value="${country.IdF}" escapeXml="false"/></a></font></c:when>
                    <c:when test="${(empty country.IdF)}"><br/><br/><img src='/ChainMap/script/ammap/icons/IdF.png'/><br/><font color="#838383"><b>Identity Federation: </b></font><font color="#0669CE">Non existent</font></c:when></c:choose>
                    <c:choose><c:when test="${(country.country_code !=NULL)}"><br/><br/><img src='/ChainMap/script/ammap/icons/oadr.png' style="vertical-align: central"/><br><font color="#838383"><b>Open Access Document Repository(ies): </b></font><font color="#0669CE"><a href="<%= (String)request.getSession().getAttribute("returnUrl") %>&tabs1=OADR Table View&ISO=${country.name}">See list</a></font></c:when>
                    <c:when test="${(country.country_code ==NULL)}"><br/><br/><img src='/ChainMap/script/ammap/icons/oadr.png' style="vertical-align: central"/><br><font color="#838383"><b>Open Access Document Repository(ies): </b></font><font color="#0669CE">Non existent</font></c:when></c:choose>
                    <c:choose><c:when test="${(country.country_code !=NULL)}"><br/><br/><img src='/ChainMap/script/ammap/icons/dr.png' style="vertical-align: central"/><br><font color="#838383"><b>Data Repository(ies): </b></font><font color="#0669CE"><a href="<%= (String)request.getSession().getAttribute("returnUrl") %>&tabs1=DR Table View&ISO=${country.name}">See list</a></font></c:when>
                    <c:when test="${(country.country_code ==NULL)}"><br/><br/><img src='/ChainMap/script/ammap/icons/dr.png' style="vertical-align: central"/><br><font color="#838383"><b>Data Repository(ies): </b></font><font color="#0669CE">Non existent</font></c:when></c:choose>
                    <c:if test="${(!empty country.ROC)}"><br><br/><img src='/ChainMap/script/ammap/icons/roc.png'/><br/><font color="#838383"><b>Regional Operation Centre(s): </b></font> <font color="#0669CE"><c:out value="<%=rtrim(roc,',')%>" escapeXml="false"/> </font></c:if>
                    <c:if test="${(!empty country.SITE_CHAIN) or (!empty country.SITE_IGI)}"><br/><br/><img src='/ChainMap/script/ammap/icons/network_1.png'/><br/><font color="#838383"><b>Grid site(s): </b></font><font color="#0669CE"><c:out value="<%=rtrim(site,',')%>" escapeXml="false"/><c:out value="<%=rtrim(siteigi,',')%>" escapeXml="false"/></font></c:if>
                    <c:if test="${(!empty country.APPLICATION)}"><br/><img src='/ChainMap/script/ammap/icons/app.png'/><br><font color="#838383"><b>Application(s): </b></font><font color="#0669CE"> <c:out value="<%=rtrim(apps,',')%>" escapeXml="false"/> </font></c:if>
                    </textformat>]]>
                </description>
                <movies>
                    <movie long="<c:out value="${country.longitude}"/>" lat="<c:out value="${country.latitude}"/>" file="icons/pin.swf"   title="<c:out value="${country.capitalCity}" escapeXml="false"/>" fixed_size="true" />
                </movies>
               </area>
            </c:if>
           <c:if test="${empty country.ROC and empty country.REG and empty country.NREN and country.balloon == 1}">
              <area  color="#a5a6a7" mc_name="<c:out value="${country.iso2Code}"/>" title="<c:out value="${country.name}"/>"/>
           </c:if>
           <c:if test="${country.balloon == 0}">
              <area  mc_name="<c:out value="${country.iso2Code}"/>" balloon="false"/>
           </c:if>
        </c:forEach>
        </areas>
        <movies>
            <movie file="home" x="50" y="71" url="!<%= request.getContextPath()%>/script/drill_down/ammap_data.xml"/>
        <c:forEach var="country" items="${areas.rows}">
            <c:if test="${((!empty country.REG) or (!empty country.NREN) or (!empty country.ROC)) and country.balloon == 1}">
                <movie long="<c:out value="${country.longitude}"/>" lat="<c:out value="${country.latitude}"/>" file="icons/pin.swf" title="<c:out value="${country.capitalCity}"  escapeXml="false" />" fixed_size="true" />
            </c:if>
        </c:forEach>
    </movies>
    <labels>
        <label x="60" y="60" url="!<%= request.getContextPath()%>/script/drill_down/ammap_data.xml" remain="true" color_hover="#CC0000" zoom_x="0%" zoom_y="0" zoom="100%"><text><![CDATA[<b>Back</b>]]></text></label>
    </labels>
</map>