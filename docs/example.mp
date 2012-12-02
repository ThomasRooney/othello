input metauml;

beginfig(1);
    Class.server("Node.js Server")()();
    
    Class.httpGet("HTTP GET")()();

    Class.webSocOne("Client 1 WebSocket")()();

    Class.webSocTwo("Client 2 WebSocket")()();

    Class.clientOne("Client 1")()();

    Class.clientTwo("Client 2")()();


    server.nw = (0, 0);

    % centered_allign_top(httpGet)(10);




    centered_allign_top(webSocOne, webSocTwo)(10, below(server.s, 20));


    centered_allign_top(clientOne, clientTwo)(10, below(server.s, 50));

    drawObjects(server, clientOne, clientTwo, httpGet, webSocOne, webSocTwo);

    link(aggregationUni)(pathStepY(clientOne.n, server.w, 61));

    link(aggregationUni)(pathStepY(clientTwo.n, server.e, 61));

    link(inheritance)(pathStepY(clientOne.n + (15, 0), server.s, 20));

    link(inheritance)(pathStepY(clientTwo.n - (15, 0), server.s, 20));
endfig;

end