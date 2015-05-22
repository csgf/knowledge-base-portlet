<%           /**************************************************************************
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
<%@page import="java.net.URLDecoder"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="javax.portlet.*"%>
<%@page contentType="text/html; charset=UTF-8" %> 
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>
<%@taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="liferay-ui" uri="http://liferay.com/tld/ui"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/css">
    div#container {
    width: 90%;
    border: 1px solid #000;
    text-align: center;
    }
    div.split2 div {
    float: left;
    width: 50%;
    }
    div.wide {
    clear: left;
    }
</script>
<portlet:defineObjects />
<%          PortletPreferences prefs = renderRequest.getPreferences();
            String tabNames = "Countries,DCI Map,DCI Table,OADR Map,OADR Table,DR Map,DR Table,OER Map,OER Table";

            String tabs1 = ParamUtil.getString(request, "tabs1", "Countries");
            PortletURL url = renderResponse.createRenderURL();
            pageContext.setAttribute("tabs1", tabs1);
            

%> 


<liferay-ui:tabs
names="<%= tabNames%>"
url="<%= url.toString()%>"
    />

<c:choose>
    <c:when test="${tabs1 == 'Countries'}" >
        <p>To navigate the map, click on the continent and then on the countries where
            you see a pin in correspondence of their capitals. <br>To see some detailed 
            information you must have your personal certificate installed in the web browser.
        </p>
        <div id="flashcontent" style="width:945px; height:650px">
            <strong>You need to upgrade your Flash Player</strong>
        </div>

        <script type="text/javascript">
            // <![CDATA[

            AUI().use('swfobject', function(A){
                var so = new SWFObject("<%=renderRequest.getContextPath()%>/script/ammap/ammap.swf", "ammap", "100%", "100%", "8", "");
                so.addVariable("path", "<%=renderRequest.getContextPath()%>/script/ammap/");
                so.addParam("wmode","transparent");
                so.addVariable("data_file", escape("<%=renderRequest.getContextPath()%>/script/drill_down/ammap_data.xml"));
                so.addVariable("settings_file", escape("<%=renderRequest.getContextPath()%>/script/drill_down/ammap_settings.xml"));
                so.addVariable("preloader_color", "#999999");
                so.write("flashcontent");
                //    new SWFObject(); // SWFObject is now ready
            });
            // ]]>
        </script>
    </c:when>
    <c:when test="${tabs1 == 'DCI Map'}" >
        <p>Click on a green marker to get more information on the corresponding Grid site.
            Data are taken from the Grid Operation Centre DataBase (GOCDB) in which the site
            is registered. <br/>To see the details of a site you must have your personal certificate installed in the web browser.</p>

        <div align="center">

            <sql:query var="results" dataSource="jdbc/ChainMap">
                (SELECT SHORT_NAME, LATITUDE, LONGITUDE, ROC, SITE_DESCRIPTION, CERTIFICATION_STATUS, GOCDB_PORTAL_URL FROM chain_site WHERE !FIND_IN_SET( COUNTRY_CODE,'AM,AZ,GB,AD,AL,AT,BA,BE,BG,BY,CH,CY,CZ,DE,DK,EE,ES,FI,FO,FR,GG,GI,GR,HR,HU,IE,IL,IM,IS,IT,JE,LI,LT,LU,LV,MC,MD,ME,MK,MT,NL,NO,PL,PT,RO,RS,RU,SE,SI,SJ,SK,SM,TR,UA,UK,VA,YU,JP') AND PRODUCTION_INFRASTRUCTURE = 'Production') UNION (SELECT SHORT_NAME, LATITUDE, LONGITUDE, ROC, SITE_DESCRIPTION, CERTIFICATION_STATUS, GOCDB_PORTAL_URL FROM igi_data WHERE !FIND_IN_SET( COUNTRY_CODE,'AM,AZ,GB,AD,AL,AT,BA,BE,BG,BY,CH,CY,CZ,DE,DK,EE,ES,FI,FO,FR,GG,GI,GR,HR,HU,IE,IL,IM,IS,IT,JE,LI,LT,LU,LV,MC,MD,ME,MK,MT,NL,NO,PL,PT,RO,RS,RU,SE,SI,SJ,SK,SM,TR,UA,UK,VA,YU,JP') AND PRODUCTION_INFRASTRUCTURE = 'Production')
            </sql:query>
            <script type="text/javascript">

                google.load("earth", "1");
                var ge;
            
               
                function geControl(controlDiv, map) {

                    var imgTag = document.createElement('IMG');
                    imgTag.src = '<%=renderRequest.getContextPath()%>/flags/google-earth.png';
                    imgTag.width ='48';
                    imgTag.title ='Switch to google earth';
                    imgTag.style.cursor='pointer';
                    controlDiv.appendChild(imgTag);

                    google.maps.event.addDomListener(imgTag, 'click', function() {
                        initialize3DMap();
                    });


                }
            
                function addMarker(map, m) {
                     
                    var marker = new google.maps.Marker({
                        position:  new google.maps.LatLng(m.latitude, m.longitude),
                        title: m.title,
                        map: map,
                        visible: (m.latitude == 0 && m.longitude == 0) ? false : true,
                        icon: "<%= renderRequest.getContextPath()%>/script/ammap/icons/tick_circle.png"
                    });
                    google.maps.event.addListener(marker, 'click', function() {
                        m.info.window.setContent(m.info.content);
                        m.info.window.open(map,marker)
                    });

                }
                function initialize2DMap() {
                    $('#map_canvas').contents().filter(function(){$(this).remove});

                    var map = new google.maps.Map(document.getElementById("map_canvas"), {
                        zoom: 2,
                        center: new google.maps.LatLng(20,30),
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    
                    })
                

                    var infoWindow = new google.maps.InfoWindow();

                <c:forEach var="data" items="${results.rows}">
                    <c:set var="GOCDB_PORTAL_URL_2D" value="${data.GOCDB_PORTAL_URL}" />
                    <jsp:useBean  id="GOCDB_PORTAL_URL_2D" type="java.lang.String"/>
                            addMarker(map, {
                                latitude:   <c:out value="${data.LATITUDE}"/>,
                                longitude:  <c:out value="${data.LONGITUDE}"/>,
                                title:      "<c:out value="${data.SHORT_NAME}"/>",
                                info:       {
                                    window: infoWindow,
                                    content:    '<div style="font-family:Arial, Helvetica, sans-serif;  font-size:10px">' +
                                        '<b>Site Name: </b><c:out value="${data.SHORT_NAME}"/><br/>' +
                                        '<b>Status:</b><c:out value="${data.CERTIFICATION_STATUS}"/><br/>'+
                    <c:if test="${!empty data.SITE_DESCRIPTION}">
                                    '<b>Site Description: </b><c:out value="${data.SITE_DESCRIPTION}"/><br/>'+
                    </c:if>
                                    '<b><a <a href="<%= URLDecoder.decode(GOCDB_PORTAL_URL_2D)%>" target="_blank">View Site</a></b>'
                                }
                            });
             
                </c:forEach>
                        var geControlDiv = document.createElement('DIV');
                        new geControl(geControlDiv, map);
                        geControlDiv.index = 1;
                        map.controls[google.maps.ControlPosition.RIGHT_TOP].push(geControlDiv);
                
                    }
                    function addPlaceMark(m) {

                        if (m.latitude !== 0 && m.longitude !== 0){
                            // Create the placemark.
                            var placemark = ge.createPlacemark('');
                            placemark.setName(m.title);

                            // Set the placemark's location.  
                            var point = ge.createPoint('');
                            point.setLatitude(m.latitude);
                            point.setLongitude(m.longitude);
                            placemark.setGeometry(point);
    
                            placemark.setDescription(m.content);
                            ge.getFeatures().appendChild(placemark);
                        }
                    }
                    function initialize3DMap() {


                        $('#map_canvas').contents().filter(function(){$(this).remove});
                        $('<div>', {
                            html: $('<img/>', {'src':'<%=renderRequest.getContextPath()%>/flags/google-maps-2d.png', 'title':'2D'}).css({'cursor':'pointer'}).click(function(){
                                initialize2DMap();
                            })
                        }).css({
                            'position':'absolute',
                            'z-index':9999
                        }).prependTo($('#map_canvas'));

                        google.earth.createInstance("map_canvas",
                        function(instance) {
                            ge = instance;
                            var la = ge.createLookAt('');
                            la.set(42.345, 12.321, 0, ge.ALTITUDE_RELATIVE_TO_GROUND, 0, 0, 5000000);
                            ge.getView().setAbstractView(la);
                            ge.getWindow().setVisibility(true);
                            ge.getNavigationControl().setVisibility(ge.VISIBILITY_SHOW);

                <c:forEach var="data" items="${results.rows}">

                    <c:set var="GOCDB_PORTAL_URL_3d" value="${data.GOCDB_PORTAL_URL}" />
                    <jsp:useBean  id="GOCDB_PORTAL_URL_3d" type="java.lang.String"/>
                                addPlaceMark({
                                    latitude:   <c:out value="${data.LATITUDE}"/>,
                                    longitude:  <c:out value="${data.LONGITUDE}"/>,
                                    title:      "<c:out value="${data.SHORT_NAME}"/>",
                                    content:    '<div style="font-family:Arial, Helvetica, sans-serif;  font-size:10px">' +
                                        '<b>Site Name: </b><c:out value="${data.SHORT_NAME}"/><br/>' +
                                        '<b>Status:</b><c:out value="${data.CERTIFICATION_STATUS}"/><br/>'+
                    <c:if test="${!empty data.SITE_DESCRIPTION}">
                                    '<b>Site Description: </b><c:out value="${data.SITE_DESCRIPTION}"/><br/>'+
                    </c:if>
                                    '<b><a href="<%= URLDecoder.decode(GOCDB_PORTAL_URL_3d)%>">View Site</a></b>'
                                });
             
                </c:forEach>

                            
                        },
                        function(){  // failure
                            
                        }
                    );
               
                    }
                    $(document).ready(function(){
                        initialize2DMap();
                    });
            </script>

            <div id="map_canvas"></div>

        </div>
    </c:when>
    <c:when test="${tabs1 == 'DCI Table'}" >
        <DIV style="width: 950px; margin: 0;">
            <script type="text/javascript">
                $.fn.dataTableExt.oJUIClasses.sSortAsc  = "chain-table-sort-header ui-state-active";
                $.fn.dataTableExt.oJUIClasses.sSortDesc  = "chain-table-sort-header ui-state-active";
                $(document).ready(function() {
                    new FixedHeader(
                    $('#view').dataTable( {
                        "sDom": '<"wrapper"<"H"<"clear"T>f<"clear"l><"right"p>t<"F"ip>>',
                        "bRetrieve": true,
                        "bJQueryUI": true,
                        "aoColumns": [
                            { "sWidth": "10%" },
                            { "sWidth": "10%" },
                            { "sWidth": "10%" },
                            { "sWidth": "15%" },
                            { "sWidth": "10%" },
                            { "sWidth": "10%" },
                            { "sWidth": "10%" },
                            { "sWidth": "10%" },
                            { "sWidth": "15%" }
                        ],
                        "oTableTools": {
                            "sSwfPath": "<%= renderRequest.getContextPath()%>/datatables/extras/TableTools/media/swf/copy_cvs_xls_pdf.swf",
                            "aButtons": [
                                "copy",
                                "print",
                                {
                                    "sExtends":    "collection",
                                    "sButtonText": "Save",
                                    "aButtons":    [ "csv","pdf" ]
                                }
                            ]},
                        "sPaginationType": "full_numbers"
                    })) ;
                    $('#view tr td a' ).each(function(){
                        $(this).attr('target', '_blank');
                    });
                });
            </script>
            <table id="view" style="width:100%">
                <thead>
                    <tr>
                        <th>
                            Country
                        </th>
                        <th>
                            Regional Net
                        </th>
                        <th>
                            NREN
                        </th>
                        <th>
                            NGI
                        </th>
                        <th>
                            CA
                        </th>
                        <th>
                            IdF
                        </th>

                        <th>
                            ROC
                        </th>
                        <th>
                            Grid site(s)
                        </th>
                        <th>
                            Application(s)
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <sql:query var="queryInst" dataSource="jdbc/ChainMap">
                        SELECT * FROM `all_vista` LEFT JOIN _country on iso2code=ISOCode WHERE NOT ISOcode ="JP" and ROC IS NOT NULL or NREN IS NOT NULL OR REG IS NOT NULL
                    </sql:query>
                    <c:forEach var="riga" items="${queryInst.rows}">


                        <tr>
                            <td align="center"><img src="<%= renderRequest.getContextPath()%>/flags/<c:out value="${riga.ISOcode}"/>.png" title="<c:out value="${riga.ISOcode}"/>"/><p style="text-align:center; font-size: 11px; font-weight: bold;"><c:out value="${riga.name}"/></p></td>
                            <td><a href="<c:out value="${riga.REG_URL}" />" target="_blank"><c:out value="${riga.REG}" escapeXml="false"/></a></td>
                            <td><a href="<c:out value="${riga.NREN_URL}" />" target="_blank"><c:out value="${riga.NREN}" escapeXml="false"/></a></td>
                            <td align="center">
                                <c:if test="${!empty riga.NGI}">
                                    <a href="<c:out value="${riga.NGI_URL}"/>" target="_blank"><c:out value="${riga.NGI}"/></a></td>
                                </c:if>
                            <td>
                                <c:if test="${!empty riga.CA}">
                                    <ul><li><a href="<c:out value="${riga.URL_CA}"/>" target="_blank"><c:out value="${riga.CA}"/></a> (<c:out value="${riga.PMA}"/>)</li></ul>
                                </c:if>
                            </td>
                            <td align="center">
                                <c:choose>
                                    <c:when test="${!empty riga.IdF}">
                                        <a href="<c:out value="${riga.URL_IdF}"/>" target="_blank"><c:out value="${riga.IdF}"/></a>
                                    </c:when>
                                    <c:when test="${empty riga.IdF}">
                                        Non existent
                                    </c:when>
                                </c:choose>
                            </td>
                            <td><a href="<c:out value="${riga.ROC_URL}"/>" target="_blank"><c:out value="${riga.ROC}" escapeXml="false"/></a></td>
                            <td>
                                <c:if test="${!empty riga.SITE_CHAIN}">
                                    <c:out value="${riga.SITE_CHAIN}" escapeXml="false"/>
                                </c:if>
                                <c:if test="${!empty riga.SITE_IGI}">
                                    <c:out value="${riga.SITE_IGI}" escapeXml="false"/>
                                </c:if>
                            </td>

                            <td><c:out value="${riga.APPLICATION}" escapeXml="false"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </DIV>
    </c:when>
    <c:when test="${tabs1 == 'OADR Map'}" >
        <script type="text/javascript">
            var icons = [];
            
            icons["data1"] =new google.maps.MarkerImage( 
            'http://maps.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png'
                   
        );
            icons["data"] =new google.maps.MarkerImage(
            'http://maps.google.com/intl/en_us/mapfiles/ms/micons/yellow-dot.png'
                
        );
        </script>
        <p> 
            Red markers refer to data currently taken from the almost 2,500 Open Access Document Repositories (OADRs) of <a href="http://www.driver-repository.eu/" target="blank">DRIVER</a>, <a href="https://www.openaire.eu/" target="blank">OpenAIRE</a>, and <a href="http://www.opendoar.org/" target="_blank">OpenDOAR</a> and currently refer to more than 30 million documents.
            Yellow markers refer to other OADRs, e.g. those of <a href="http://lareferencia.redclara.net/" target="blank">LA Referencia</a> in Latin America, added thanks to the work done by CHAIN-REDS.
            Click on a marker to get more information on the corresponding OADR.</p>
        <div align="center">

            <sql:query var="results" dataSource="jdbc/ChainMap">
                (SELECT name_rep, link_rep, lat, long_rep, institution, dominio, country_code, name FROM `openDOAR` LEFT JOIN _country on country_code=iso2Code where lat is not null and long_rep is not null)
            </sql:query>
            <sql:query var="results_new" dataSource="jdbc/ChainMap">
                (SELECT name_rep, link_rep, lat, long_rep, institution, dominio, country_code, name FROM `openDOAR_partners` LEFT JOIN _country on country_code=iso2Code where lat is not null and long_rep is not null)
            </sql:query>

            <script type="text/javascript">

                google.load("earth", "1");
                var ge;
            

                function geControl(controlDiv, map) {

                    var imgTag = document.createElement('IMG');
                    imgTag.src = '<%=renderRequest.getContextPath()%>/flags/google-earth.png';
                    imgTag.width ='48';
                    imgTag.title ='Switch to google earth';
                    imgTag.style.cursor='pointer';
                    controlDiv.appendChild(imgTag);

                    google.maps.event.addDomListener(imgTag, 'click', function() {
                        initialize3DMap();
                    });


                }
            
                function addMarker(map, m) {
                   
                    var marker = new google.maps.Marker({
                        position:  new google.maps.LatLng(m.latitude, m.longitude),
                        title: m.title,
                        icon: m.icon,
                        map: map,
                        zIndex: m.zIndex,
                        visible: (m.latitude == 0 && m.longitude == 0) ? false : true
                        
                    });
                    google.maps.event.addListener(marker, 'click', function() {
                        m.info.window.setContent(m.info.content);
                        m.info.window.open(map,marker)
                    });

                }
                function initialize2DMap() {
                    $('#map_canvas').contents().filter(function(){$(this).remove});

                    var map = new google.maps.Map(document.getElementById("map_canvas"), {
                        zoom: 2,
                        center: new google.maps.LatLng(20,30),
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    
                    })
                

                    var infoWindow = new google.maps.InfoWindow();
                <c:forEach var="data" items="${results_new.rows}">
                        addMarker(map, {
                            latitude:   <c:out value="${data.lat}"/>,
                            longitude:  <c:out value="${data.long_rep}"/>,
                            title:      "<c:out value="${data.name_rep}"/>",
                            icon: icons["data"],
                            info:       {
                                window: infoWindow,
                                content:    '<div style="font-family:Arial, Helvetica, sans-serif;  font-size:10px">' +
                                    '<b>OADR: </b><a href="<c:out value="${data.link_rep}" />" target="_blank"><c:out value="${data.name_rep}"/></a><br/>'+
                                    '<b>Domain(s): </b><c:out value="${data.dominio}" escapeXml="false"/><br/>' +
                                    '<b>Organization: </b><c:out value="${data.institution}" escapeXml="false"/><br/>' +
                                    '<b>Country: </b><c:out value="${data.name}" escapeXml="false"/></div>'
                                 
                                
                            },
                            zIndex: google.maps.Marker.MAX_ZINDEX + 1
                        });
             
                </c:forEach>
                <c:forEach var="data1" items="${results.rows}">
                    
                        addMarker(map, {
                            latitude:   <c:out value="${data1.lat}"/>,
                            longitude:  <c:out value="${data1.long_rep}"/>,
                            title:      "<c:out value="${data1.name_rep}"/>",
                            icon: icons["data1"],
                            info:       {
                                window: infoWindow,
                                content:    '<div style="font-family:Arial, Helvetica, sans-serif;  font-size:10px">' +
                                    '<b>OADR: </b><a href="<c:out value="${data1.link_rep}" />" target="_blank"><c:out value="${data1.name_rep}"/></a><br/>'+
                                    '<b>Domain(s): </b><c:out value="${data1.dominio}" escapeXml="false"/><br/>' +
                                    '<b>Organization: </b><c:out value="${data1.institution}" escapeXml="false"/><br/>' +
                                    '<b>Country: </b><c:out value="${data1.name}" escapeXml="false"/></div>'
                                 
                                
                            },
                            zIndex:0
                                
                        });
             
                </c:forEach>
                        var geControlDiv = document.createElement('DIV');
                        new geControl(geControlDiv, map);
                        geControlDiv.index = 1;
                        map.controls[google.maps.ControlPosition.RIGHT_TOP].push(geControlDiv);
                
                    }
                    function addPlaceMark(m) {

                        if (m.latitude !== 0 && m.longitude !== 0){
                            // Create the placemark.
                            var placemark = ge.createPlacemark('');
                            placemark.setName(m.title);

                            // Set the placemark's location.  
                            var point = ge.createPoint('');
                            point.setLatitude(m.latitude);
                            point.setLongitude(m.longitude);
                            placemark.setGeometry(point);
    
                            placemark.setDescription(m.content);
                            ge.getFeatures().appendChild(placemark);
                        }
                    }
                    function initialize3DMap() {


                        $('#map_canvas').contents().filter(function(){$(this).remove});
                        $('<div>', {
                            html: $('<img/>', {'src':'<%=renderRequest.getContextPath()%>/flags/google-maps-2d.png', 'title':'2D'}).css({'cursor':'pointer'}).click(function(){
                                initialize2DMap();
                            })
                        }).css({
                            'position':'absolute',
                            'z-index':9999
                        }).prependTo($('#map_canvas'));

                        google.earth.createInstance("map_canvas",
                        function(instance) {
                            ge = instance;
                            var la = ge.createLookAt('');
                            la.set(42.345, 12.321, 0, ge.ALTITUDE_RELATIVE_TO_GROUND, 0, 0, 5000000);
                            ge.getView().setAbstractView(la);
                            ge.getWindow().setVisibility(true);
                            ge.getNavigationControl().setVisibility(ge.VISIBILITY_SHOW);

                <c:forEach var="data" items="${results.rows}">

                            addPlaceMark({
                                latitude:   <c:out value="${data.lat}"/>,
                                longitude:  <c:out value="${data.long_rep}"/>,
                                title:      "",
                                content:    '<div style="font-family:Arial, Helvetica, sans-serif;  font-size:10px">' +
                                    '<b>OADR: </b><c:out value="${data.name_rep}"/><br/>'+
                                    '<b>Domain(s): </b><c:out value="${data.dominio}" escapeXml="false"/><br/>' +
                                    '<b>Organization: </b><c:out value="${data.institution}" escapeXml="false"/><br/>' +
                                    '<b>Country: </b><c:out value="${data.name}" escapeXml="false"/></div>'
                            });
             
                </c:forEach>

                            
                        },
                        function(){  // failure
                            
                        }
                    );
               
                    }
                    $(document).ready(function(){
                        initialize2DMap();
                    });
            </script>

            <div id="map_canvas"></div>

        </div>

    </c:when>
    <c:when test="${tabs1 == 'OADR Table'}" >
        <p>

            Cells highlighted in yellow, e.g. those of <a href="http://lareferencia.redclara.net/" target="blank">LA Referencia</a>, refer to other OADRs added thanks to the work done by CHAIN-REDS. 
        </p>

        <DIV style="width: 950px; margin: 0;">
            <script type="text/javascript">
                
                $.fn.dataTableExt.oJUIClasses.sSortAsc  = "chain-table-sort-header ui-state-active";
                $.fn.dataTableExt.oJUIClasses.sSortDesc  = "chain-table-sort-header ui-state-active";
                $(document).ready(function() {
                    var oTable= $('#view').dataTable( {
                        "sDom": '<"wrapper"<"H"<"clear"T>f<"clear"l><"right"p>t<"F"ip>>',
                        "bRetrieve": true,
                        "bJQueryUI": true,
                        "aoColumns": [
                            { "sWidth": "15%" },
                            { "sWidth": "35%" },
                            { "sWidth": "15%" },
                            { "sWidth": "35%" },
                          
                        ],
                        "oTableTools": {
                            "sSwfPath": "<%= renderRequest.getContextPath()%>/datatables/extras/TableTools/media/swf/copy_cvs_xls_pdf.swf",
                            "aButtons": [
                                "copy",
                                "print",
                                {
                                    "sExtends":    "collection",
                                    "sButtonText": "Save",
                                    "aButtons":    [ "csv","pdf" ]
                                }
                            ]},
                        "sPaginationType": "full_numbers"
                        
                    });
                    
                <%
                    if(request.getParameter("ISO")!=null){
                %>
                        oTable.fnFilter("<%= request.getParameter("ISO") %>", 0);
                <%
                    }%>
                            new FixedHeader(oTable) ;
                            $('#view tr td a' ).each(function(){
                                $(this).attr('target', '_blank');
                            });
                    
                     
                        });
            </script>
            <table id="view" style="width:100%">
                <thead>
                    <tr>
                        <th>
                            Country
                        </th>
                        <th>
                            Name
                        </th>
                        <th>Domain
                        </th>
                        <th>
                            Organization
                        </th>


                    </tr>
                </thead>
                <tbody>
                    <sql:query var="queryInst" dataSource="jdbc/ChainMap">
                        SELECT name_rep, link_rep, lat, long_rep, institution, dominio, country_code, name FROM `openDOAR` LEFT JOIN _country on country_code=iso2Code
                    </sql:query>
                    <sql:query var="queryInst1" dataSource="jdbc/ChainMap">
                        SELECT name_rep, link_rep, lat, long_rep, institution, dominio, country_code, name FROM `openDOAR_partners` LEFT JOIN _country on country_code=iso2Code 
                    </sql:query>
                    <c:forEach var="riga" items="${queryInst.rows}">
                        <tr>
                            <td align="center"><img src="<%= renderRequest.getContextPath()%>/flags/<c:out value="${riga.country_code}"/>.png" title="<c:out value="${riga.country_code}"/>"/><p style="text-align:center; font-size: 11px; font-weight: bold;"><c:out value="${riga.name}"/></p></td>
                            <td><a href="<c:out value="${riga.link_rep}" />" target="_blank"><c:out value="${riga.name_rep}" escapeXml="false"/></a></td>
                            <td><c:out value="${riga.dominio}" escapeXml="false"/></td>
                            <td><c:out value="${riga.institution}" escapeXml="false"/></td>


                        </tr>
                    </c:forEach>
                    <c:forEach var="riga1" items="${queryInst1.rows}">
                        <tr style="background-color: yellow">
                            <td align="center"><img src="<%= renderRequest.getContextPath()%>/flags/<c:out value="${riga1.country_code}"/>.png" title="<c:out value="${riga1.country_code}"/>"/><p style="text-align:center; font-size: 11px; font-weight: bold;"><c:out value="${riga1.name}"/></p></td>
                            <td><a href="<c:out value="${riga1.link_rep}" />" target="_blank"><c:out value="${riga1.name_rep}" escapeXml="false"/></a></td>
                            <td><c:out value="${riga1.dominio}" escapeXml="false"/></td>
                            <td><c:out value="${riga1.institution}" escapeXml="false"/></td>


                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </DIV>
    </c:when>
    <c:when test="${tabs1 == 'DR Map'}" >
        <script type="text/javascript">
            var icons = [];
            
            icons["data1"] =new google.maps.MarkerImage( 
            'http://maps.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png'
                   
        );
            icons["data"] =new google.maps.MarkerImage(
            'http://maps.google.com/intl/en_us/mapfiles/ms/micons/yellow-dot.png'
                
        );
        </script>

        <p>Red markers refer to data currently taken from the more than 500 Data Repositories of <a href="http://databib.org/" target="_lank">Databib</a> and <a href="http://www.datacite.org/" target="_lank">DataCite</a>. Yellow markers refer to other DRs, e.g. that of <a href="http://www.zenodo.org/" target="_lank">ZENODO</a>, added thanks to the work done by CHAIN-REDS. Click on a marker to get more information on the corresponding DR.</p>

        <div align="center">


            <sql:query var="results" dataSource="jdbc/ChainMap">
                SELECT `City`, `Lat`, `Long`, concat('<ul>',group_concat(concat('<li>', concat('<img src="<%=renderRequest.getContextPath()%>/flags/rep.png"> <a href="',URL,'" target="_blank">'), name_rep,'</a></li>') SEPARATOR ''),'</ul>') as name_all_rep FROM Repositories group by City
                    </sql:query>
                    <sql:query var="results_new" dataSource="jdbc/ChainMap">
                SELECT `City`, `Lat`, `Long`, concat('<ul>',group_concat(concat('<li>', concat('<img src="<%=renderRequest.getContextPath()%>/flags/rep.png"> <a href="',URL,'" target="_blank">'), name_rep,'</a></li>') SEPARATOR ''),'</ul>') as name_all_rep FROM Repositories_partners group by City
                    </sql:query>
            <script type="text/javascript">

                google.load("earth", "1");
                var ge;
            

                function geControl(controlDiv, map) {

                    var imgTag = document.createElement('IMG');
                    imgTag.src = '<%=renderRequest.getContextPath()%>/flags/google-earth.png';
                    imgTag.width ='48';
                    imgTag.title ='Switch to google earth';
                    imgTag.style.cursor='pointer';
                    controlDiv.appendChild(imgTag);

                    google.maps.event.addDomListener(imgTag, 'click', function() {
                        initialize3DMap();
                    });


                }
            
                function addMarker(map, m) {
                
                    var marker = new google.maps.Marker({
                        position:  new google.maps.LatLng(m.latitude, m.longitude),
                        title: m.title,
                        icon: m.icon,
                        map: map,
                        zIndex: m.zIndex,
                        visible: (m.latitude == 0 && m.longitude == 0) ? false : true      
                    });
                    google.maps.event.addListener(marker, 'click', function() {
                        m.info.window.setContent(m.info.content);
                        m.info.window.open(map,marker)
                    });

                }
                function initialize2DMap() {
                    $('#map_canvas').contents().filter(function(){$(this).remove});

                    var map = new google.maps.Map(document.getElementById("map_canvas"), {
                        zoom: 2,
                        center: new google.maps.LatLng(20,30),
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    
                    })
                

                    var infoWindow = new google.maps.InfoWindow();

                <c:forEach var="data" items="${results_new.rows}">
                        addMarker(map, {
                            latitude:   <c:out value="${data.Lat}"/>,
                            longitude:  <c:out value="${data.Long}"/>,
                            title:      "Repositories",
                            icon: icons["data"],
                            info:       {
                                window: infoWindow,
                                content:    
                                    '<b>Repositories: </b><c:out value="${data.name_all_rep}" escapeXml="false"/>'
                                 
                                
                            },
                            zIndex: google.maps.Marker.MAX_ZINDEX + 1
                                
                        });
                        
                </c:forEach>
                <c:forEach var="data1" items="${results.rows}">
                        addMarker(map, {
                            latitude:   <c:out value="${data1.Lat}"/>,
                            longitude:  <c:out value="${data1.Long}"/>,
                            title:      "Repositories",
                            icon: icons["data1"],
                            info:       {
                                window: infoWindow,
                                content:    
                                    '<b>Repositories: </b><c:out value="${data1.name_all_rep}" escapeXml="false"/>'
                                 
                                
                            },
                            zIndex:0
                                
                        });
                        
                </c:forEach>
                        var geControlDiv = document.createElement('DIV');
                        new geControl(geControlDiv, map);
                        geControlDiv.index = 1;
                        map.controls[google.maps.ControlPosition.RIGHT_TOP].push(geControlDiv);
                
                    }
                    function addPlaceMark(m) {

                        if (m.latitude !== 0 && m.longitude !== 0){
                            // Create the placemark.
                            var placemark = ge.createPlacemark('');
                            placemark.setName(m.title);

                            // Set the placemark's location.  
                            var point = ge.createPoint('');
                            point.setLatitude(m.latitude);
                            point.setLongitude(m.longitude);
                            placemark.setGeometry(point);
    
                            placemark.setDescription(m.content);
                            ge.getFeatures().appendChild(placemark);
                        }
                    }
                    function initialize3DMap() {


                        $('#map_canvas').contents().filter(function(){$(this).remove});
                        $('<div>', {
                            html: $('<img/>', {'src':'<%=renderRequest.getContextPath()%>/flags/google-maps-2d.png', 'title':'2D'}).css({'cursor':'pointer'}).click(function(){
                                initialize2DMap();
                            })
                        }).css({
                            'position':'absolute',
                            'z-index':9999
                        }).prependTo($('#map_canvas'));

                        google.earth.createInstance("map_canvas",
                        function(instance) {
                            ge = instance;
                            var la = ge.createLookAt('');
                            la.set(42.345, 12.321, 0, ge.ALTITUDE_RELATIVE_TO_GROUND, 0, 0, 5000000);
                            ge.getView().setAbstractView(la);
                            ge.getWindow().setVisibility(true);
                            ge.getNavigationControl().setVisibility(ge.VISIBILITY_SHOW);

                <c:forEach var="data" items="${results.rows}">

                            addPlaceMark({
                                latitude:   <c:out value="${data.Lat}"/>,
                                longitude:  <c:out value="${data.Long}"/>,
                                title:      "",
                                content:    '<b>Repositories: </b><c:out value="${data.name_all_rep}" escapeXml="false"/>'
                            });
             
                </c:forEach>

                            
                        },
                        function(){  // failure
                            
                        }
                    );
               
                    }
                    $(document).ready(function(){
                        initialize2DMap();
                    });
            </script>

            <div id="map_canvas"></div>

        </div>
    </c:when>
    <c:when test="${tabs1 == 'DR Table'}" >
        <p>Data are currently taken from the more than 500 data repositories of <a href="http://databib.org/" target="_lank">Databib</a> and <a href="http://www.datacite.org/" target="_lank">DataCite</a>. Cells highlighted in yellow, e.g. that of <a href="http://www.zenodo.org/" target="_lank">ZENODO</a>, refer to other DRs added thanks to the work done by CHAIN-REDS.</p>
        <DIV style="width: 950px; margin: 0;">
            <script type="text/javascript">
                
                $.fn.dataTableExt.oJUIClasses.sSortAsc  = "chain-table-sort-header ui-state-active";
                $.fn.dataTableExt.oJUIClasses.sSortDesc  = "chain-table-sort-header ui-state-active";
                $(document).ready(function() {
                    var oTable= $('#view').dataTable( {
                        "sDom": '<"wrapper"<"H"<"clear"T>f<"clear"l><"right"p>t<"F"ip>>',
                        "bRetrieve": true,
                        "bJQueryUI": true,
                        "aoColumns": [
                            { "sWidth": "15%" },
                            { "sWidth": "35%" },
                            { "sWidth": "15%" },
                            { "sWidth": "35%" },
                          
                        ],
                        "oTableTools": {
                            "sSwfPath": "<%= renderRequest.getContextPath()%>/datatables/extras/TableTools/media/swf/copy_cvs_xls_pdf.swf",
                            "aButtons": [
                                "copy",
                                "print",
                                {
                                    "sExtends":    "collection",
                                    "sButtonText": "Save",
                                    "aButtons":    [ "csv","pdf" ]
                                }
                            ]},
                        "sPaginationType": "full_numbers"
                        
                    });
                    
                <%
                    if(request.getParameter("ISO")!=null){
                %>
                        oTable.fnFilter("<%= request.getParameter("ISO") %>", 0);
                <%
                    }%>
                            new FixedHeader(oTable) ;
                            $('#view tr td a' ).each(function(){
                                $(this).attr('target', '_blank');
                            });
                    
                     
                        });
            </script>
            <table id="view" style="width:100%">
                <thead>
                    <tr>
                        <th>
                            Country
                        </th>
                        <th>
                            Name
                        </th>
                        <th>Domain
                        </th>
                        <th>
                            Organization
                        </th>


                    </tr>
                </thead>
                <tbody>
                    <sql:query var="queryInst" dataSource="jdbc/ChainMap">
                        SELECT name_rep, URl, Domain, Authority, country, iso2Code FROM `Repositories` LEFT JOIN _country on country=name
                    </sql:query>
                    <sql:query var="queryInst2" dataSource="jdbc/ChainMap">
                        SELECT name_rep, URl, Domain, Authority, country, iso2Code FROM `Repositories_partners` LEFT JOIN _country on country=name
                    </sql:query>
                    <c:forEach var="riga" items="${queryInst.rows}">
                        <tr>
                            <td align="center"><img src="<%= renderRequest.getContextPath()%>/flags/<c:out value="${riga.iso2Code}"/>.png" title="<c:out value="${riga.country}"/>"/><p style="text-align:center; font-size: 11px; font-weight: bold;"><c:out value="${riga.country}"/></p></td>
                            <td><a href="<c:out value="${riga.URl}" />" target="_blank"><c:out value="${riga.name_rep}" escapeXml="false"/></a></td>
                            <td><c:out value="${riga.Domain}" escapeXml="false"/></td>
                            <td><c:out value="${riga.Authority}" escapeXml="false"/></td>


                        </tr>
                    </c:forEach>
                    <c:forEach var="riga1" items="${queryInst2.rows}">
                        <tr style="background-color: yellow">
                            <td align="center"><img src="<%= renderRequest.getContextPath()%>/flags/<c:out value="${riga1.iso2Code}"/>.png" title="<c:out value="${riga1.country}"/>"/><p style="text-align:center; font-size: 11px; font-weight: bold;"><c:out value="${riga1.country}"/></p></td>
                            <td><a href="<c:out value="${riga1.URl}" />" target="_blank"><c:out value="${riga1.name_rep}" escapeXml="false"/></a></td>
                            <td><c:out value="${riga1.Domain}" escapeXml="false"/></td>
                            <td><c:out value="${riga1.Authority}" escapeXml="false"/></td>


                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </DIV>
    </c:when>   
    <c:when test="${tabs1 == 'OER Map'}">
        <script type="text/javascript">
            var icons = [];
                       
            icons["data"] =new google.maps.MarkerImage(
            'http://maps.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png'
                
        );
        </script>
        <p>Markers refer to Open Educational Repositories (OERs) available all over the world.</p>
        <DIV style="width: 950px; margin: 0;">

            <sql:query var="results" dataSource="jdbc/ChainMap">
                SELECT `City`, `Latitude`, `Longitude`, concat('<ul>',group_concat(concat('<li>', concat('<img src="<%=renderRequest.getContextPath()%>/flags/rep.png"> <a href="',URL,'" target="_blank">'), acronym,'</a></li>') SEPARATOR ''),'</ul>') as name FROM oer_repo group by City
                    </sql:query>
            <script type="text/javascript">

                google.load("earth", "1");
                var ge;
            

                function geControl(controlDiv, map) {

                    var imgTag = document.createElement('IMG');
                    imgTag.src = '<%=renderRequest.getContextPath()%>/flags/google-earth.png';
                    imgTag.width ='48';
                    imgTag.title ='Switch to google earth';
                    imgTag.style.cursor='pointer';
                    controlDiv.appendChild(imgTag);

                    google.maps.event.addDomListener(imgTag, 'click', function() {
                        initialize3DMap();
                    });


                }
            
                function addMarker(map, m) {
                
                    var marker = new google.maps.Marker({
                        position:  new google.maps.LatLng(m.latitude, m.longitude),
                        title: m.title,
                        icon: m.icon,
                        map: map,
                        zIndex: m.zIndex,
                        visible: (m.latitude == 0 && m.longitude == 0) ? false : true      
                    });
                    google.maps.event.addListener(marker, 'click', function() {
                        m.info.window.setContent(m.info.content);
                        m.info.window.open(map,marker)
                    });

                }
                function initialize2DMap() {
                    $('#map_canvas').contents().filter(function(){$(this).remove});

                    var map = new google.maps.Map(document.getElementById("map_canvas"), {
                        zoom: 2,
                        center: new google.maps.LatLng(20,30),
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    
                    })
                

                    var infoWindow = new google.maps.InfoWindow();

                <c:forEach var="data" items="${results.rows}">
                        addMarker(map, {
                            latitude:   <c:out value="${data.Latitude}"/>,
                            longitude:  <c:out value="${data.Longitude}"/>,
                            title:      "Repositories",
                            icon: icons["data"],
                            info:       {
                                window: infoWindow,
                                content:    
                                    '<b>Repositories: </b><c:out value="${data.name}" escapeXml="false"/>'
                                 
                                
                            },
                            zIndex: google.maps.Marker.MAX_ZINDEX + 1
                                
                        });
                        
                </c:forEach>
           
                        var geControlDiv = document.createElement('DIV');
                        new geControl(geControlDiv, map);
                        geControlDiv.index = 1;
                        map.controls[google.maps.ControlPosition.RIGHT_TOP].push(geControlDiv);
                
                    }
                    function addPlaceMark(m) {

                        if (m.latitude !== 0 && m.longitude !== 0){
                            // Create the placemark.
                            var placemark = ge.createPlacemark('');
                            placemark.setName(m.title);

                            // Set the placemark's location.  
                            var point = ge.createPoint('');
                            point.setLatitude(m.latitude);
                            point.setLongitude(m.longitude);
                            placemark.setGeometry(point);
    
                            placemark.setDescription(m.content);
                            ge.getFeatures().appendChild(placemark);
                        }
                    }
                    function initialize3DMap() {


                        $('#map_canvas').contents().filter(function(){$(this).remove});
                        $('<div>', {
                            html: $('<img/>', {'src':'<%=renderRequest.getContextPath()%>/flags/google-maps-2d.png', 'title':'2D'}).css({'cursor':'pointer'}).click(function(){
                                initialize2DMap();
                            })
                        }).css({
                            'position':'absolute',
                            'z-index':9999
                        }).prependTo($('#map_canvas'));

                        google.earth.createInstance("map_canvas",
                        function(instance) {
                            ge = instance;
                            var la = ge.createLookAt('');
                            la.set(42.345, 12.321, 0, ge.ALTITUDE_RELATIVE_TO_GROUND, 0, 0, 5000000);
                            ge.getView().setAbstractView(la);
                            ge.getWindow().setVisibility(true);
                            ge.getNavigationControl().setVisibility(ge.VISIBILITY_SHOW);

                <c:forEach var="data" items="${results.rows}">

                            addPlaceMark({
                                latitude:   <c:out value="${data.Latitude}"/>,
                                longitude:  <c:out value="${data.Longitude}"/>,
                                title:      "",
                                content:    '<b>Repositories: </b><c:out value="${data.name}" escapeXml="false"/>'
                            });
             
                </c:forEach>

                            
                        },
                        function(){  // failure
                            
                        }
                    );
               
                    }
                    $(document).ready(function(){
                        initialize2DMap();
                    });
            </script>

            <div id="map_canvas"></div>
        </DIV>
    </c:when>   
    <c:when test="${tabs1 == 'OER Table'}" >
        <p>The table contains Open Educational Repositories (OERs) available all over the world.</p>
        <DIV style="width: 950px; margin: 0;">
            <script type="text/javascript">
                
                $.fn.dataTableExt.oJUIClasses.sSortAsc  = "chain-table-sort-header ui-state-active";
                $.fn.dataTableExt.oJUIClasses.sSortDesc  = "chain-table-sort-header ui-state-active";
                $(document).ready(function() {
                    var oTable= $('#view').dataTable( {
                        "sDom": '<"wrapper"<"H"<"clear"T>f<"clear"l><"right"p>t<"F"ip>>',
                        "bRetrieve": true,
                        "bJQueryUI": true,
                        "aoColumns": [
                            { "sWidth": "15%" },
                            { "sWidth": "35%" },
                            { "sWidth": "15%" },
                            { "sWidth": "35%" },
                          
                        ],
                        "oTableTools": {
                            "sSwfPath": "<%= renderRequest.getContextPath()%>/datatables/extras/TableTools/media/swf/copy_cvs_xls_pdf.swf",
                            "aButtons": [
                                "copy",
                                "print",
                                {
                                    "sExtends":    "collection",
                                    "sButtonText": "Save",
                                    "aButtons":    [ "csv","pdf" ]
                                }
                            ]},
                        "sPaginationType": "full_numbers"
                        
                    });
                    
                <%
                        if(request.getParameter("ISO")!=null){
                %>
                        oTable.fnFilter("<%= request.getParameter("ISO") %>", 0);
                <%
                        }%>
                                new FixedHeader(oTable) ;
                                $('#view tr td a' ).each(function(){
                                    $(this).attr('target', '_blank');
                                });
                    
                     
                            });
            </script>
            <table id="view" style="width:100%">
                <thead>
                    <tr>
                        <th>
                            Country
                        </th>
                        <th>
                            Name
                        </th>
                        <th>Domain
                        </th>
                        <th>
                            Organization
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <sql:query var="queryInst" dataSource="jdbc/ChainMap">
                        SELECT acronym, url, domain, organisation, Country,iso2Code  FROM `oer_repo` LEFT JOIN _country on country=name
                    </sql:query>
                    <c:forEach var="riga" items="${queryInst.rows}">
                        <tr>
                            <td align="center"><img src="<%= renderRequest.getContextPath()%>/flags/<c:out value="${riga.iso2Code}"/>.png" title="<c:out value="${riga.Country}"/>"/><p style="text-align:center; font-size: 11px; font-weight: bold;"><c:out value="${riga.country}"/></p></td>
                            <td><a href="<c:out value="${riga.url}" />" target="_blank"><c:out value="${riga.acronym}" escapeXml="false"/></a></td>
                            <td><c:out value="${riga.domain}" escapeXml="false"/></td>
                            <td><c:out value="${riga.organisation}" escapeXml="false"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table> 
        </DIV>
    </c:when>   

    <c:otherwise>
        No tabs
    </c:otherwise>
</c:choose>    