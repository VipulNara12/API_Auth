*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    BuiltIn
*** Variables ***
${baseUrl}      https://simple-grocery-store-api.glitch.me
${name}     Vipul Nara

*** Test Cases ***
ApiAuth
#    CreateCart
    GetProductsAndAddProduct

*** Keywords ***
GetProductsAndAddProduct
    create session    mysession    ${baseUrl}
    ${bearer_body}=   create dictionary    clientName=Vipul   clientEmail=vipul@gmail1.com
    ${bearer}=     post on session    mysession    /api-clients    json=${bearer_body}
    ${bearer_token}=    get from dictionary    ${bearer.json()}   accessToken
    log    ${bearer_token}

    ${response}=    post    ${baseUrl}/carts
    ${cartId}=    get from dictionary    ${response.json()}   cartId
    log    ${cartId}

    ${response_product}=    GET    ${baseUrl}/products
    ${product}=     get value from json    ${response_product.json()}   $.[0]
    log    ${product}
    ${productDict}=   get from list    ${product}   0
    log    ${productDict}
    ${productId}=   get from dictionary    ${productDict}   id
    log     ${productId}
    set global variable    ${productID}

    ${dict}=    create dictionary   productId=${productId}
    ${response_prod}=   post    ${baseUrl}/carts/${cartId}/items    json=${dict}
    log    ${response_prod.json()}

    ${header}=      create dictionary    Authorization=${bearer_token}
    ${order_dict}=      create dictionary    cartId=${cartId}    customerName=${name}
    ${create_order}=    post    ${baseUrl}/orders    json=${order_dict}      headers=${header}


    ${get_orders}=  GET    ${baseUrl}/orders   headers=${header}
    log    ${get_orders.json()}


displayVariable
    log    ${productID}