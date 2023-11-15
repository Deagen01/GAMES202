class PRTMaterial extends Material {

    constructor(PrecomputeLRGB, vertexShader, fragmentShader) {

        //precomputeLT
        //顶点数7905×SH系数个数9 传入的只要是1×9的vector
        //precomputeL SH系数个数9×SHvector长度3      
        super({
            'uPrecomputeLR':{type:'matrix3fv',value:PrecomputeLRGB[0]},
            'uPrecomputeLG':{type:'matrix3fv',value:PrecomputeLRGB[1]},
            'uPrecomputeLB':{type:'matrix3fv',value:PrecomputeLRGB[2]},
        }, [
            'aPrecomputeLT'
        ], vertexShader, fragmentShader, null);
    }
}

async function buildPRTMaterial(PrecomputeLRGB,vertexPath, fragmentPath) {

    console.log("asumc build");
    let vertexShader = await getShaderString(vertexPath);
    let fragmentShader = await getShaderString(fragmentPath);
    
    return new PRTMaterial(PrecomputeLRGB, vertexShader, fragmentShader);

}
async function test(){
    console.log("I am a test");
}